import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/sources/sources.dart';

import 'common.dart';
import 'chain_event_converter_test.reflectable.dart';

void main() {
  final converter = ChainEventsConverter();

  setUpAll(() {
    initializeReflectable();
    initializeCodec();
  });

  test('ChainEventsConverter returns valid data', () {
    final file = File("test_resources/chain/tx_with_events_response.json");
    final tx = Transaction.fromJson(jsonDecode(file.readAsStringSync()));

    final expected = <ChainEvent>[
      PostCreatedEvent(
        postId: "193",
        owner: "desmos1xzg3en5c6zt73qefkytw7xjlp5kl57spjphf2x",
        parentId: "0",
        height: "413730",
      ),
      PostEvent(
        postId: "192",
        height: "413730",
      ),
      PostEvent(
        postId: "192",
        height: "413730",
      )
    ];

    final result = converter.convert("413730", tx.logs);
    expect(result, expected);
  });
}
