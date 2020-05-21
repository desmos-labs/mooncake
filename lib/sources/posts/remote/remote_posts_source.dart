import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';

import 'converters/converters.dart';
import 'helpers/helpers.dart';

/// Source that is responsible for handling the communication with the
/// blockchain, allowing to read incoming posts and send new ones.
class RemotePostsSourceImpl implements RemotePostsSource {
  final ChainSource _chainSource;
  final LocalUserSource _userSource;
  final RemoteMediasSource _remoteMediasSource;

  // Converters
  final PostsMsgConverter _msgConverter;

  // GraphQL
  GraphQLClient _gqlClient;

  /// Public constructor
  RemotePostsSourceImpl({
    @required GraphQLClient graphQLClient,
    @required ChainSource chainHelper,
    @required LocalUserSource userSource,
    @required RemoteMediasSource remoteMediasSource,
    @required PostsMsgConverter msgConverter,
  })  : assert(graphQLClient != null),
        _gqlClient = graphQLClient,
        assert(userSource != null),
        _userSource = userSource,
        assert(chainHelper != null),
        _chainSource = chainHelper,
        assert(remoteMediasSource != null),
        _remoteMediasSource = remoteMediasSource,
        assert(msgConverter != null),
        _msgConverter = msgConverter;

  @override
  Future<List<Post>> getHomePosts({
    @required int start,
    @required int limit,
  }) async {
    final data = HomePostsData(
      subspace: Constants.SUBSPACE,
      start: start,
      limit: limit,
    );
    return GqlPostsHelper.getHomePosts(_gqlClient, data);
  }

  @override
  Stream<dynamic> get homeEventsStream {
    final query = """subscription HomeEvents {
    ${GqlPostsHelper.homeEvents}
    }""";
    return _gqlClient.subscribe(Operation(documentNode: gql(query)));
  }

  /// Returns the [Post] object having the given [postId]
  /// retrieved from the remote source. If no post with such id could
  /// be found, `null` is returned instead.
  @override
  Future<Post> getPostById(String postId) async {
    final data = PostDetailsData(
      subspace: Constants.SUBSPACE,
      id: postId,
    );
    return GqlPostsHelper.getPostDetails(_gqlClient, data);
  }

  @override
  Future<List<Post>> getPostComments(String postId) async {
    final data = PostDetailsData(
      subspace: Constants.SUBSPACE,
      id: postId,
    );
    return GqlPostsHelper.getPostComments(_gqlClient, data);
  }

  @override
  Future<TransactionResult> savePosts(List<Post> posts) async {
    final wallet = await _userSource.getWallet();

    // Get the existing posts list
    final List<Post> existingPosts = await Future.wait(posts.map((post) {
      return getPostById(post.id);
    }).toList());

    // Upload the medias
    final postsWithIpfsMedias = await _uploadMediasIfNecessary(posts);

    // Convert the posts into messages
    final messages = _msgConverter.convertPostsToMsg(
      posts: postsWithIpfsMedias,
      existingPosts: existingPosts,
      wallet: wallet,
    );

    // Get the result of the transactions
    return _chainSource.sendTx(messages, wallet);
  }

  /// Allows to upload the media of each [posts] item if necessary.
  /// Returns a list of [Post] that have each one a reference to a
  /// remote media.
  Future<List<Post>> _uploadMediasIfNecessary(List<Post> posts) async {
    final newPosts = List<Post>(posts.length);
    for (int index = 0; index < posts.length; index++) {
      final post = posts[index];

      if (!post.containsLocalMedias) {
        // No local medias, nothing to do
        newPosts[index] = post;
        continue;
      }

      // Upload the medias if necessary
      final uploadedMedias = await Future.wait(post.medias.map((media) async {
        final file = File(media.url);
        if (!file.existsSync()) {
          // Already remote, do nothing
          return media;
        }

        // Upload to IPFS and return a new media with the changed URL
        final ipfsUrl = await _remoteMediasSource.uploadMedia(file);
        return media.copyWith(url: ipfsUrl);
      }));
      newPosts[index] = post.copyWith(medias: uploadedMedias);
    }

    return newPosts;
  }
}
