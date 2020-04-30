import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/sources/sources.dart';
import 'package:web_socket_channel/io.dart';

import '../common.dart';
import 'remote_posts_source_test.reflectable.dart';
import '../../../mocks/posts.dart';

class MockChainHelper extends Mock implements ChainHelper {}

class MockLocalUserSource extends Mock implements LocalUserSource {}

class MockMsgConverter extends Mock implements MsgConverter {}

void main() {
  HttpServer server;
  ChainHelper chainHelper;
  LocalUserSource userSource;
  MsgConverter msgConverter;

  RemotePostsSourceImpl source;

  setUpAll(() {
    initializeReflectable();
    initializeCodec();
  });

  setUp(() async {
    server = await HttpServer.bind("localhost", 0);
    chainHelper = MockChainHelper();
    userSource = MockLocalUserSource();
    msgConverter = MockMsgConverter();
    source = RemotePostsSourceImpl(
      graphQlEndpoint: "${server.address}:${server.port}",
      chainHelper: chainHelper,
      userSource: userSource,
      msgConverter: msgConverter,
    );
  });

  tearDown(() async {
    await server?.close();
  });

  /// Sets the [chainHelper] to response with the contents of the file
  /// having the specified [fileName] when [endpoint] is called.
  void setResponse({@required String endpoint, @required String fileName}) {
    final contents = File(fileName).readAsStringSync();
    when(chainHelper.queryChainRaw(endpoint))
        .thenAnswer((_) => Future.value(jsonDecode(contents)));
  }

  test('getHomePosts returns the proper data', () async {
    final data = r'''
    {
      "data": {
        "posts": [
          {
            "id": "76597beaa2698925b5b30fd991d3e8f720fa1a0234ffc6549b61948917ee5bd7",
            "subspace": "2bdf5932925584b9a86470bea60adce69041608a447f84a3317723aa5678ec88",
            "created": "2020-04-30T09:08:03.746",
            "last_edited": "0001-01-01T00:00:00",
            "media": [],
            "message": "Why people celebrate Buddha and Jesus birthday?",
            "optional_data": null,
            "parent_id": null,
            "reactions": [],
            "user": {
              "address": "desmos1fc3mdf0ue2f4suyg5vjj75jtaer0cl0dgqvy6u",
              "moniker": null,
              "pictures": []
            },
            "comments": []
          },
          {
            "id": "64d6a0562f599a1ebf799748f2ba3c2b27e9b340f59a4d9bbd765940402e00bd",
            "subspace": "2bdf5932925584b9a86470bea60adce69041608a447f84a3317723aa5678ec88",
            "created": "2020-04-30T08:05:46.992",
            "last_edited": "0001-01-01T00:00:00",
            "media": [
              {
                "uri": "https://ipfs.desmos.network/ipfs/QmPKQBed922AEDThJ3pVeJPk7B4hm9z8uJxzg4v8EHZGhb",
                "mime_type": "image/jpeg"
              }
            ],
            "message": "A good read from one of the best italian's physicist, \"The order of time\" explain in a visceral way what really the time is, making your normal time conception fall off like a house of cards",
            "optional_data": null,
            "parent_id": null,
            "reactions": [
              {
                "user": {
                  "address": "desmos1fc3mdf0ue2f4suyg5vjj75jtaer0cl0dgqvy6u"
                },
                "value": "❤"
              }
            ],
            "user": {
              "address": "desmos14dm0zdemeymhayucp7gchuus3k5m344f3v8nln",
              "moniker": null,
              "pictures": []
            },
            "comments": []
          }
        ]
      }
    }
    ''';

  });
}
