import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/sources/sources.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

/// Source that is responsible for handling the communication with the
/// blockchain, allowing to read incoming posts and send new ones.
class RemotePostsSourceImpl implements RemotePostsSource {
  static const _BLOCK_HEIGHT_KEY = "block_height";

  final String _rpcEndpoint;
  final ChainHelper _chainHelper;
  final LocalUserSource _walletSource;

  // Streams
  final _postsStream = StreamController<Post>();
  StreamSubscription _subscription;

  // Converters
  final _postJsonConverter = PostJsonConverter();
  final _msgConverter = MsgConverter();
  final _eventsConverter = ChainEventsConverter();

  /// Public constructor
  RemotePostsSourceImpl({
    @required String rpcEndpoint,
    @required ChainHelper chainHelper,
    @required LocalUserSource walletSource,
  })  : assert(rpcEndpoint != null),
        _rpcEndpoint = rpcEndpoint,
        assert(walletSource != null),
        _walletSource = walletSource,
        assert(chainHelper != null),
        _chainHelper = chainHelper;

  /// Observes the chain events
  StreamSubscription _observeEvents() {
    // Setup the channel
    final rpcUrl = _rpcEndpoint.replaceAll(RegExp('http(s)?:\/\/'), "");
    final channel = IOWebSocketChannel.connect('ws://$rpcUrl/websocket');

    // Get the given query list or use the default set
    final queryList = [
      "tm.event='Tx'",
    ];

    // Send a subscription message for each query
    queryList.forEach((query) {
      channel.sink.add(jsonEncode({
        "jsonrpc": "2.0",
        "method": "subscribe",
        "id": "0",
        "params": {
          "query": query,
        }
      }));
    });

    // Observe each new message and handle it properly
    return channel.stream
        // We need to skip the initial messages answering OK for the queries
        .skip(queryList.length)
        .map((data) => TxEvent.fromJson(jsonDecode(data)))
        .handleError((error) => print('Remote posts channel exception: $error'))
        .listen((query) async {
      final height = query.result.data.value.txResult.height;
      await _parseBlock(height);
    });
  }

  Future<void> _parseBlock(String height) async {
    final endpoint = "/txs?tx.height=$height";
    final response = await _chainHelper.queryChainRaw(endpoint);
    final txData = TxResponse.fromJson(response);

    if (txData.txs.isEmpty) {
      // No txs, nothing to do
      return;
    }

    print('Parsing block at height $height');
    txData.txs.forEach((tx) {
      final events = _eventsConverter.convert(height, tx.events);
      events.forEach((event) async {
        await _handleEvent(event);
      });
    });
  }

  /// Handles properly the given [event].
  Future<void> _handleEvent(ChainEvent event) async {
    // Handle the event properly
    if (event is PostCreatedEvent) {
      return _handlePostCreatedEvent(event);
    } else if (event is PostEvent) {
      return _handlePostEvent(event);
    }
  }

  /// Handles the messages telling that a new post has been created.
  Future<void> _handlePostCreatedEvent(PostCreatedEvent event) async {
    final post = await getPostById(event.postId);

    // Emit the updated parent
    if (post?.hasParent == true) {
      final parent = await getPostById(post.parentId);
      if (parent != null) {
        _postsStream.add(parent);
      }
    }

    // Emit the updated post
    _postsStream.add(post);
  }

  Future<void> _handlePostEvent(PostEvent event) async {
    final post = await getPostById(event.postId);
    _postsStream.add(post);
  }

  @override
  Stream<Post> get postsStream {
    return _postsStream.stream;
  }

  @override
  Future<Post> getPostById(String postId) async {
    try {
      final data = await _chainHelper.queryChain("/posts/$postId");
      final post = Post.fromJson(data.result);
      return post.copyWith(
          status: PostStatus(
        value: PostStatusValue.SYNCED,
      ));
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<void> startSyncPosts() async {
    if (_subscription == null) {
      print("Initializing remote source posts stream");
      _subscription = _observeEvents();
    }

    int page = 1;
    bool fetchNext = true;

    while (fetchNext) {
      final endpoint = "/posts?limit=100&page=${page++}";
      final response = await _chainHelper.queryChainRaw(endpoint);
      final postsResponse = PostsResponse.fromJson(response);

      // Stream all the posts
      for (final postJson in postsResponse.posts) {
        _postsStream.add(_postJsonConverter.toPost(postJson));
      }

      // Tell whether or not to stop
      fetchNext = postsResponse.posts?.isNotEmpty == true;
    }
  }

  @override
  Future<List<Post>> getPostComments(String postId) async {
    final post = await getPostById(postId);
    return Future.wait(post.commentsIds.map((comment) async {
      return await getPostById(postId);
    }).toList());
  }

  @override
  Future<void> savePosts(List<Post> posts) async {
    final wallet = await _walletSource.getWallet();

    // Get the existing posts list
    final List<Post> existingPosts =
        await Future.wait(posts.map((p) => getPostById(p.id)));

    // Convert the posts into messages
    final messages = _msgConverter.convertPostsToMsg(
      posts: posts,
      existingPosts: existingPosts,
      wallet: wallet,
    );

    // Get the result of the transactions
    await _chainHelper.sendTx(messages, wallet);
  }

  @override
  Future<void> deletePost(String postId) {
    throw UnimplementedError("Cannot delete a remote post");
  }
}
