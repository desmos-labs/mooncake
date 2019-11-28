import 'dart:async';
import 'dart:convert';

import 'package:desmosdemo/models/models.dart';
import 'package:desmosdemo/sources/remote/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:web_socket_channel/io.dart';

/// Source that is responsible for handling the communication with the
/// blockchain, allowing to read incoming posts and send new ones.
class RemotePostsSource {
  static const _LCD_ENDPOINT = "http://10.0.2.2:1317";
  static const _RPC_ENDPOINT = "ws://10.0.2.2:26657";

  final http.Client _httpClient;

  final _channel = IOWebSocketChannel.connect('$_RPC_ENDPOINT/websocket');

  // TODO: We should probably cancel this 
  // ignore: cancel_subscriptions
  StreamSubscription _subscription;

  final StreamController<Post> _postsStream = StreamController();

  RemotePostsSource({
    @required http.Client httpClient,
  })  : assert(httpClient != null),
        _httpClient = httpClient;

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
        .listen((data) => _handleMessage(data));
  }

  /// Returns a [Stream] emitting new posts each time they are sent
  /// to the chain.
  Stream<Post> get postsStream {
    if (_subscription == null) {
      print("Initializing remote source posts stream");
      _subscription = _initObserve();
    }
    return _postsStream.stream;
  }

  /// Handles the message contained inside the given [TxData].
  void _handleMessage(TxData data) async {
    final events = data.result.events;
    if (events != null) {
      print(events);
      switch (events["message.action"][0]) {
        case "create_post":
          _handlePostCreated(events);
          break;
      }
    }
  }

  /// Utility method to easily query any chain endpoint and
  /// read the response as an [LcdResponse] object instance.
  Future<LcdResponse> _queryChain(String endpoint) async {
    final url = _LCD_ENDPOINT + endpoint;
    final data = await _httpClient.get(url);
    if (data.statusCode != 200) {
      throw Exception("Expected response code 200, got: ${data.statusCode}");
    }
    return LcdResponse.fromJson(json.decode(data.body));
  }

  Post _convertPost(PostJson json) {
    return Post(
      id: json.id,
      parentId: json.parentId,
      message: json.message,
      created: json.created,
      lastEdited: json.lastEdited,
      allowsComments: json.allowsComments,
      owner: User(
        address: json.owner,
        username: null, // TODO: Get this from somewhere
        avatarUrl: null, // TODO: Get this from somewhere
      ),
      likes: json.likes.map((l) {
        // TODO: Map the likes
      }).toList(),
      commentsIds: json.commentsIds,
      synced: true,
    );
  }

  /// Handles the messages telling that a new post has been created.
  void _handlePostCreated(Map<String, List<String>> events) async {
    final id = events["create_post.post_id"][0];
    final data = await _queryChain("/posts/$id");
    final post = _convertPost(PostJson.fromJson(data.result));
    _postsStream.add(post);
  }
}
