import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/sources/sources.dart';
import 'package:web_socket_channel/io.dart';

/// Source that is responsible for handling the communication with the
/// blockchain, allowing to read incoming posts and send new ones.
class RemotePostsSourceImpl implements RemotePostsSource {
  final String _rpcEndpoint;
  final ChainHelper _chainHelper;
  final LocalUserSource _walletSource;

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

  @override
  Stream<ChainEvent> getEventsStream() {
    print("Initializing remote source posts stream");
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
        .map((txEvent) => txEvent.result.data.value.txResult.height)
        .asyncMap((height) => _parseBlock(height))
        .where((list) => list.isNotEmpty)
        .expand((list) => list);
  }

  /// Parses the block at the given [height, handling all the contained
  /// events.
  Future<List<ChainEvent>> _parseBlock(String height) async {
    final endpoint = "/txs?tx.height=$height";
    final response = await _chainHelper.queryChainRaw(endpoint);
    final txData = TxResponse.fromJson(response);

    if (txData.txs.isEmpty) {
      // No txs, nothing to do
      return [];
    }

    return txData.txs
        .expand((tx) => _eventsConverter.convert(height, tx.events))
        .toList();
  }

  static PostsResponse _convertResponse(Map<String, dynamic> json) {
    return PostsResponse.fromJson(json);
  }

  @override
  Future<List<Post>> getPosts() async {
    final posts = List<Post>();
    int page = 1;
    bool fetchNext = true;

    while (fetchNext) {
      final endpoint = "/posts?limit=100&page=${page++}";
      final response = await _chainHelper.queryChainRaw(endpoint);
      final postsResponse = await compute(_convertResponse, response);
      posts.addAll(postsResponse.posts
          .map((p) => _postJsonConverter.toPost(p))
          .toList());

      fetchNext = postsResponse.posts.isNotEmpty;
    }

    return posts;
  }

  @override
  Future<Post> getPostById(String postId) async {
    try {
      final data = await _chainHelper.queryChain("/posts/$postId");
      final post = Post.fromJson(data.result);
      return post.copyWith(status: PostStatus(value: PostStatusValue.SYNCED));
    } catch (e) {
      print(e);
      return null;
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
