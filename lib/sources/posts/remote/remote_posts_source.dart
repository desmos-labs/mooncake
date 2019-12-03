import 'dart:async';
import 'dart:convert';

import 'package:desmosdemo/entities/entities.dart';
import 'package:desmosdemo/repositories/repositories.dart';
import 'package:desmosdemo/sources/sources.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:sacco/sacco.dart';
import 'package:web_socket_channel/io.dart';

import 'post_converter.dart';

/// Source that is responsible for handling the communication with the
/// blockchain, allowing to read incoming posts and send new ones.
class RemotePostsSource implements PostsSource {
  final String _lcdEndpoint;
  final String _rpcEndpoint;
  final http.Client _httpClient;
  final WalletSource _walletSource;

  // ignore: cancel_subscriptions
  StreamSubscription _subscription;
  IOWebSocketChannel _channel;

  final converter = PostConverter();
  final StreamController<Post> _postsStream = StreamController();

  RemotePostsSource({
    @required String lcdEndpoint,
    @required String rpcEndpoint,
    @required http.Client httpClient,
    @required WalletSource walletSource,
  })  : assert(lcdEndpoint != null && lcdEndpoint.isNotEmpty),
        _lcdEndpoint = lcdEndpoint,
        assert(rpcEndpoint != null && rpcEndpoint.isNotEmpty),
        _rpcEndpoint = rpcEndpoint,
        assert(httpClient != null),
        _httpClient = httpClient,
        assert(walletSource != null),
        _walletSource = walletSource {
    _channel = IOWebSocketChannel.connect('$_rpcEndpoint/websocket');
  }

  /// Initializes the web socket connection and starts observing new
  /// messages.
  StreamSubscription _initObserve() {
    // Get the given query list or use the default set
    final queryList = [
      "message.action='create_post'",
      "message.action='edit_post'",
      "message.action='like_post'",
    ];

    // Send a subscription message for each query
    queryList.forEach((query) {
      _channel.sink.add(jsonEncode({
        "jsonrpc": "2.0",
        "method": "subscribe",
        "id": "0",
        "params": {
          "query": query,
        }
      }));
    });

    // Observe each new message and handle it properly
    return _channel.stream
        // We need to skip the initial messages answering OK for the queries
        .skip(queryList.length)
        .map((data) => TxData.fromJson(jsonDecode(data)))
        .handleError((error) => print('Remote posts channel exception: $error'))
        .listen((data) => _handleMessage(data));
  }

  /// Handles the message contained inside the given [TxData].
  void _handleMessage(TxData data) async {
    final events = data.result.events;
    if (events != null) {
      print(events);
      switch (events["message.action"][0]) {
        case "create_post":
          _handlePostCreatedMsg(events);
          break;
      }
    }
  }

  /// Handles the messages telling that a new post has been created.
  void _handlePostCreatedMsg(Map<String, List<String>> events) async {
    final id = events["create_post.post_id"][0];
    final post = await getPostById(id);
    _postsStream.add(post);
  }

  /// Utility method to easily query any chain endpoint and
  /// read the response as an [LcdResponse] object instance.
  Future<LcdResponse> _queryChain(String endpoint) async {
    final url = _lcdEndpoint + endpoint;
    final data = await _httpClient.get(url);
    if (data.statusCode != 200) {
      throw Exception("Expected response code 200, got: ${data.statusCode}");
    }
    return LcdResponse.fromJson(json.decode(data.body));
  }

  /// Creates, sings and sends a transaction having the given [messages]
  /// and using the given [wallet].
  Future<void> _sendTx(List<StdMsg> messages, Wallet wallet) async {
    final tx = TxBuilder.buildStdTx(stdMsgs: messages);
    final signTx = await TxSigner.signStdTx(wallet: wallet, stdTx: tx);
    final result = await TxSender.broadcastStdTx(wallet: wallet, stdTx: signTx);
    if (!result.success) {
      throw Exception(result.error.errorMessage);
    }
  }

  @override
  Stream<Post> get postsStream {
    if (_subscription == null) {
      print("Initializing remote source posts stream");
      _subscription = _initObserve();
    }
    return _postsStream.stream;
  }

  @override
  Future<Post> getPostById(String postId) async {
    try {
      final data = await _queryChain("/posts/$postId");
      final post = converter.toPost(PostJson.fromJson(data.result));
      return post;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<List<Post>> getPosts() {
    // TODO: implement getPosts
    throw UnimplementedError();
  }

  @override
  Future<void> savePost(Post post) async {
    final wallet = await _walletSource.getWallet();
    final msg = converter.toMsgCreatePost(post);
    return _sendTx([msg], wallet);
  }

  @override
  Future<void> savePosts(List<Post> posts) async {
    final wallet = await _walletSource.getWallet();
    final msgs = posts.map((post) => converter.toMsgCreatePost(post)).toList();
    return _sendTx(msgs, wallet);
  }

  @override
  Future<void> deletePost(String postId) {
    throw UnimplementedError("Cannot delete a remote post");
  }
}
