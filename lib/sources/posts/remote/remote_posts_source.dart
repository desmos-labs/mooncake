import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/sources/sources.dart';
import 'package:mooncake/utils/utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/io.dart';

/// Source that is responsible for handling the communication with the
/// blockchain, allowing to read incoming posts and send new ones.
class RemotePostsSourceImpl implements RemotePostsSource {
  final ChainHelper _chainHelper;
  final LocalUserSource _userSource;

  // Converters
  final MsgConverter _msgConverter;

  // Stream controllers
  final _postsController = BehaviorSubject<List<Post>>();

  /// Public constructor
  RemotePostsSourceImpl({
    @required String graphQlEndpoint,
    @required ChainHelper chainHelper,
    @required LocalUserSource userSource,
    @required MsgConverter msgConverter,
  })  : assert(userSource != null),
        _userSource = userSource,
        assert(chainHelper != null),
        _chainHelper = chainHelper,
        assert(msgConverter != null),
        _msgConverter = msgConverter {
    // Init GraphQL
    _initGql(graphQlEndpoint);
  }

  void _initGql(String graphQlEndpoint) {
    // Init the GraphQL
    final gqlWsLink = WebSocketLink(url: "ws://$graphQlEndpoint");
    final client = GraphQLClient(link: gqlWsLink, cache: InMemoryCache());
    final postsSub = """
    subscription posts {
      post(order_by: {created: desc}, where: {subspace: {_eq: "${Constants.SUBSPACE}"}}) {
        id
        allows_comments
        created
        last_edited
        message
        optional_data
        parent_id
        subspace
        poll {
          allows_multiple_answers
          allows_answer_edits
          end_date
          id
          open
          poll_answers {
            answer_id
            answer_text
          }
          user_poll_answers {
            user {
              address
            }
            answer
          }
        }
        user {
          address
        }
      }
    }
    """;
    client.subscribe(Operation(documentNode: gql(postsSub))).listen((event) {
      // TODO: Convert the posts
    });
  }

  @override
  Stream<List<Post>> get postsStream => _postsController.stream;

  @override
  Future<void> savePosts(List<Post> posts) async {
    final wallet = await _userSource.getWallet();

    // Get the existing posts list
    final List<Post> existingPosts =
        await Future.wait(posts.map((p) => getPostById(p.id).first).toList());

    // Upload the medias
    final postsWithIpfsMedias = await _uploadMediasIfNecessary(posts);

    // Convert the posts into messages
    final messages = _msgConverter.convertPostsToMsg(
      posts: postsWithIpfsMedias,
      existingPosts: existingPosts,
      wallet: wallet,
    );

    // Get the result of the transactions
    await _chainHelper.sendTx(messages, wallet);
  }

  @override
  Stream<Post> getPostById(String postId) {
    return postsStream
        .expand((list) => list)
        .where((post) => post.id == postId);
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
