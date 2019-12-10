import 'dart:async';
import 'dart:convert';

import 'package:dwitter/sources/sources.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/io.dart';

import '../converters/converters.dart';

/// Allows to easily work with events coming from the chain about new posts,
/// likes or comments.
class ChainEventHelper {
  final String _rpcEndpoint;

  /// Public constructor
  ChainEventHelper({
    @required String rpcEndpoint,
  })  : assert(rpcEndpoint != null && rpcEndpoint.isNotEmpty),
        _rpcEndpoint = rpcEndpoint;

  final _eventConverter = ChainEventsConverter();

  /// Initializes the web socket connection and starts observing new
  /// messages.
  Stream<List<ChainEvent>> initObserve() {
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
        .map((data) => TxData.fromJson(jsonDecode(data)))
        .handleError((error) => print('Remote posts channel exception: $error'))
        .map((data) {
      final Map<String, List<String>> events = data.result.events ?? {};
      return _eventConverter.convert(events);
    });
  }
}
