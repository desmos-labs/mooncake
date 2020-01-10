import 'dart:async';
import 'dart:convert';

import 'package:dwitter/entities/entities.dart';
import 'package:dwitter/repositories/repositories.dart';
import 'package:dwitter/sources/sources.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

/// Source that is responsible for handling the communication with the
/// blockchain, allowing to read incoming posts and send new ones.
class RemotePostsSourceImpl implements RemotePostsSource {
  static const _BLOCK_HEIGHT_KEY = "block_height";

  final String _rpcEndpoint;
  final ChainHelper _chainHelper;
  final WalletSource _walletSource;

  // Streams
  final _postsStream = StreamController<Post>();
  StreamSubscription _subscription;

  // Converters
  final _msgConverter = MsgConverter();
  final _eventsConverter = ChainEventsConverter();

  /// Public constructor
  RemotePostsSourceImpl({
    @required String rpcEndpoint,
    @required ChainHelper chainHelper,
    @required WalletSource walletSource,
  })  : assert(rpcEndpoint != null),
        _rpcEndpoint = rpcEndpoint,
        assert(walletSource != null),
        _walletSource = walletSource,
        assert(chainHelper != null),
        _chainHelper = chainHelper;

  /// Observes the chain events
  StreamSubscription _observeEvents() {
    // Setup the channel
    final channel = IOWebSocketChannel.connect('$_rpcEndpoint/websocket');

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

    // Store the latest synced block height
    await _saveLatestBlockHeight(height);

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

  Future<void> _handleEvent(ChainEvent event) async {
    // Handle the event properly
    if (event is PostCreatedEvent) {
      return _handlePostCreatedEvent(event);
    } else if (event is PostLikedEvent) {
      return _handlePostLikedEvent(event);
    } else if (event is PostUnlikedEvent) {
      return _handlePostUnLikedEvent(event);
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

  Future<void> _handlePostLikedEvent(PostLikedEvent event) async {
    final post = await getPostById(event.postId);
    _postsStream.add(post);
  }

  Future<void> _handlePostUnLikedEvent(PostUnlikedEvent event) async {
    final post = await getPostById(event.postId);
    _postsStream.add(post);
  }

  /// Allows to store the latest synced block height
  Future<void> _saveLatestBlockHeight(String height) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString(_BLOCK_HEIGHT_KEY, height);
  }

  @override
  Stream<Post> get postsStream {
    return _postsStream.stream;
  }

  @override
  Future<Post> getPostById(String postId) async {
    try {
      final data = await _chainHelper.queryChain("/posts/$postId");
      return Post.fromJson(data.result);
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

    // Get the latest queried block height
    final sharedPrefs = await SharedPreferences.getInstance();
    final initBlockHeight = double.parse(
      sharedPrefs.getString(_BLOCK_HEIGHT_KEY) ?? "0",
    ).toInt();

    // Get the current block height
    final response = await _chainHelper.queryChainRaw("/blocks/latest");
    final blockResponse = BlockResponse.fromJson(response);
    final endBlockHeight = double.parse(
      blockResponse.blockMeta.header.height,
    ).toInt();

    print('Syncing from block $initBlockHeight to $endBlockHeight');
    // For each block height, get the transactions
    for (int height = initBlockHeight; height <= endBlockHeight; height++) {
      _parseBlock(height.toString());
      await Future.delayed(Duration(milliseconds: 50));
    }
  }

  @override
  Future<List<Post>> getPostComments(String postId) {
    // TODO: implement getPostComments
    throw UnimplementedError();
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
