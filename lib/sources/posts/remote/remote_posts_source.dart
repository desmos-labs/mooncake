import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/sources/sources.dart';

/// Source that is responsible for handling the communication with the
/// blockchain, allowing to read incoming posts and send new ones.
class RemotePostsSourceImpl implements RemotePostsSource {
  final String graphQlEndpoint;

  final ChainHelper _chainHelper;
  final LocalUserSource _userSource;

  // Converters
  final MsgConverter _msgConverter;

  // GraphQL
  GraphQLClient _gqlClient;
  GraphQLClient _wsClient;

  /// Public constructor
  RemotePostsSourceImpl({
    @required String graphQlEndpoint,
    @required ChainHelper chainHelper,
    @required LocalUserSource userSource,
    @required MsgConverter msgConverter,
  })  : assert(graphQlEndpoint != null),
        graphQlEndpoint = graphQlEndpoint,
        assert(userSource != null),
        _userSource = userSource,
        assert(chainHelper != null),
        _chainHelper = chainHelper,
        assert(msgConverter != null),
        _msgConverter = msgConverter {
    // Init GraphQL
    _initGql(graphQlEndpoint);
  }

  /// Initializes the GraphQL clients properly so that they can be
  /// queried using [_gqlClient] and new posts will be retrieved using
  /// the [postsStream].
  void _initGql(String graphQlEndpoint) {
    // Init the query client
    _gqlClient = GraphQLClient(
      link: HttpLink(uri: "http://$graphQlEndpoint"),
      cache: InMemoryCache(),
    );
    _wsClient = GraphQLClient(
      link: WebSocketLink(url: "ws://$graphQlEndpoint"),
      cache: InMemoryCache(),
    );
  }

  @override
  Future<List<Post>> getHomePosts({
    @required int start,
    @required int limit,
  }) async {
    final data = HomePostsData(
      endpoint: graphQlEndpoint,
      subspace: Constants.SUBSPACE,
      start: start,
      limit: limit,
    );
    return GqlHelper.getHomePosts(_gqlClient, data);
  }

  @override
  Stream<dynamic> get homeEventsStream {
    final query = """subscription HomeEvents {
    ${GqlHelper.homeEvents}
    }""";
    return _wsClient.subscribe(Operation(documentNode: gql(query)));
  }

  /// Returns the [Post] object having the given [postId]
  /// retrieved from the remote source. If no post with such id could
  /// be found, `null` is returned instead.
  @override
  Future<Post> getPostById(String postId) async {
    final data = PostDetailsData(
      endpoint: graphQlEndpoint,
      subspace: Constants.SUBSPACE,
      id: postId,
    );
    return GqlHelper.getPostDetails(_gqlClient, data);
  }

  @override
  Future<List<Post>> getPostComments(String postId) async {
    final data = PostDetailsData(
      endpoint: graphQlEndpoint,
      subspace: Constants.SUBSPACE,
      id: postId,
    );
    return GqlHelper.getPostComments(_gqlClient, data);
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
    return _chainHelper.sendTx(messages, wallet);
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
        if (!media.isLocal) {
          // Already remote, do nothing
          return media;
        }

        // Upload to IPFS and return a new media with the changed URL
        final ipfsUrl = await _chainHelper.uploadMediaToIpfs(media);
        return media.copyWith(url: ipfsUrl);
      }));
      newPosts[index] = post.copyWith(medias: uploadedMedias);
    }

    return newPosts;
  }
}
