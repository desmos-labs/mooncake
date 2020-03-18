import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/sources/sources.dart';
import 'package:rxdart/rxdart.dart';

/// Source that is responsible for handling the communication with the
/// blockchain, allowing to read incoming posts and send new ones.
class RemotePostsSourceImpl implements RemotePostsSource {
  final ChainHelper _chainHelper;
  final LocalUserSource _userSource;

  // Converters
  final MsgConverter _msgConverter;

  // Stream controllers
  final _postsController = BehaviorSubject<List<Post>>();

  // GraphQL
  GraphQLClient _gqlClient;

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

  /// Returns a GraphQL [String] that allows to query for all the mooncake
  /// posts that have the given id.
  /// If no id is specified, all the posts will be considered instead.
  String _postGql({String id}) {
    String idQuery = "";
    if (id != null) {
      idQuery = 'id: {_eq: "$id"},';
    }
    return """
    post(where: {$idQuery subspace: {_eq: "${Constants.SUBSPACE}"}}, order_by: {created: desc}) {
      id
      subspace
      created
      last_edited
      media {
        uri
        mime_type
      }
      message
      optional_data
      parent_id
      reactions {
        user {
          address
        }
        value
      }
      user {
        address
      }
    }
    """;
  }

  /// Converts the given [gqlData] retrieved from the remote GraphQL
  /// server into a list of posts.
  /// If no data is present, returns an empty list instead.
  List<Post> _convertGqlResponse(dynamic gqlData) {
    final data = gqlData as Map<String, dynamic>;
    if (data.containsKey("post")) {
      return (data["post"] as List<dynamic>)
          .map((e) => Post.fromJson(e))
          .toList();
    }
    return [];
  }

  /// Initializes the GraphQL clients properly so that they can be
  /// queried using [_gqlClient] and new posts will be retrieved using
  /// the [postsStream].
  void _initGql(String graphQlEndpoint) {
    // Init the GraphQL
    _gqlClient = GraphQLClient(
      link: HttpLink(uri: "http://$graphQlEndpoint"),
      cache: InMemoryCache(),
    );

    final gqlWsLink = WebSocketLink(url: "ws://$graphQlEndpoint");
    final client = GraphQLClient(link: gqlWsLink, cache: InMemoryCache());
    final postsSub = """
    subscription Posts {
      ${_postGql()}
    }
    """;
    client.subscribe(Operation(documentNode: gql(postsSub))).listen((event) {
      print("New event: $event");
      final data = event.data as Map<String, dynamic>;
      _postsController.add(_convertGqlResponse(data));
    });
  }

  @override
  Stream<List<Post>> get postsStream => _postsController.stream;

  /// Returns the [Post] object having the given [postId]
  /// retrieved from the remote source. If no post with such id could
  /// be found, `null` is returned instead.
  Future<Post> _getPostById(String postId) async {
    final query = """
    query PostById {
      ${_postGql(id: postId)}
    }
    """;
    final data = await _gqlClient.query(QueryOptions(documentNode: gql(query)));
    final posts = _convertGqlResponse(data.data);
    if (posts.isEmpty) {
      return null;
    }
    return posts[0];
  }

  @override
  Future<void> savePosts(List<Post> posts) async {
    final wallet = await _userSource.getWallet();

    // Get the existing posts list
    final List<Post> existingPosts = await Future.wait(posts.map((post) {
      return _getPostById(post.id);
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
    await _chainHelper.sendTx(messages, wallet);
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
