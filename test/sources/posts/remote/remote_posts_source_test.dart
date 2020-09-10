import 'package:graphql/client.dart';
import 'package:mock_web_server/mock_web_server.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/sources/sources.dart';
import 'package:test/test.dart';

import '../common.dart';
import 'remote_posts_source_test.reflectable.dart';

class MockChainSource extends Mock implements ChainSource {}

class MockLocalUserSource extends Mock implements LocalUserSource {}

class MockRemoteMediasSource extends Mock implements RemoteMediasSource {}

class MockMsgConverter extends Mock implements PostsMsgConverter {}

void main() {
  MockWebServer server;
  ChainSource chainSource;
  LocalUserSource userSource;
  RemoteMediasSource remoteMediasSource;
  PostsMsgConverter msgConverter;

  RemotePostsSourceImpl source;

  setUpAll(() {
    initializeReflectable();
    initializeCodec();

    server = MockWebServer();
    server.start();
  });

  setUp(() async {
    // Clean the dispatcher to avoid cross-testing conflicts
    server.dispatcher = null;

    final link = HttpLink(
      uri: server.url,
    ).concat(WebSocketLink(
      url: server.url,
    ));
    final graphQlClient = GraphQLClient(link: link, cache: InMemoryCache());

    chainSource = MockChainSource();
    userSource = MockLocalUserSource();
    msgConverter = MockMsgConverter();
    remoteMediasSource = MockRemoteMediasSource();
    source = RemotePostsSourceImpl(
      graphQLClient: graphQlClient,
      chainHelper: chainSource,
      userSource: userSource,
      msgConverter: msgConverter,
      remoteMediasSource: remoteMediasSource,
    );
  });

  group('home related', () {
    test('getHomePosts returns the proper data', () async {
      final data = r'''
      {
        "data": {
          "posts": [
            {
              "id": "76597beaa2698925b5b30fd991d3e8f720fa1a0234ffc6549b61948917ee5bd7",
              "subspace": "2bdf5932925584b9a86470bea60adce69041608a447f84a3317723aa5678ec88",
              "allows_comments": true,
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
              "allows_comments": false,
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
      server.enqueue(body: data);

      final expected = [
        Post(
          id: '76597beaa2698925b5b30fd991d3e8f720fa1a0234ffc6549b61948917ee5bd7',
          status: PostStatus(value: PostStatusValue.TX_SUCCESSFULL),
          subspace:
              '2bdf5932925584b9a86470bea60adce69041608a447f84a3317723aa5678ec88',
          allowsComments: true,
          created: '2020-04-30T09:08:03.746',
          lastEdited: '0001-01-01T00:00:00',
          medias: [],
          message: 'Why people celebrate Buddha and Jesus birthday?',
          optionalData: {},
          parentId: null,
          reactions: [],
          owner: User(
            address: 'desmos1fc3mdf0ue2f4suyg5vjj75jtaer0cl0dgqvy6u',
            moniker: null,
            profilePicUri: null,
          ),
          commentsIds: [],
        ),
        Post(
          id: '64d6a0562f599a1ebf799748f2ba3c2b27e9b340f59a4d9bbd765940402e00bd',
          status: PostStatus(value: PostStatusValue.TX_SUCCESSFULL),
          subspace:
              '2bdf5932925584b9a86470bea60adce69041608a447f84a3317723aa5678ec88',
          created: '2020-04-30T08:05:46.992',
          lastEdited: '0001-01-01T00:00:00',
          allowsComments: false,
          medias: [
            PostMedia(
              uri:
                  'https://ipfs.desmos.network/ipfs/QmPKQBed922AEDThJ3pVeJPk7B4hm9z8uJxzg4v8EHZGhb',
              mimeType: 'image/jpeg',
            )
          ],
          message:
              "A good read from one of the best italian's physicist, \"The order of time\" explain in a visceral way what really the time is, making your normal time conception fall off like a house of cards",
          optionalData: {},
          parentId: null,
          reactions: [
            Reaction.fromValue(
              '❤',
              User.fromAddress('desmos1fc3mdf0ue2f4suyg5vjj75jtaer0cl0dgqvy6u'),
            ),
          ],
          owner: User(
            address: 'desmos14dm0zdemeymhayucp7gchuus3k5m344f3v8nln',
            moniker: null,
          ),
          commentsIds: [],
        ),
      ];
      final posts = await source.getHomePosts(start: 200, limit: 10);
      expect(posts, equals(expected));
    });

    test('data with url is fetched with preview', () async {
      final data = r'''
      {
        "data": {
          "posts": [
            {
              "id": "64d6a0562f599a1ebf799748f2ba3c2b27e9b340f59a4d9bbd765940402e00bd",
              "subspace": "2bdf5932925584b9a86470bea60adce69041608a447f84a3317723aa5678ec88",
              "allows_comments": false,
              "created": "2020-04-30T08:05:46.992",
              "last_edited": "0001-01-01T00:00:00",
              "message": "A good read from one of the best italian's physicist, \"The order of time\" explain in a visceral way what really the time is, making your normal time conception fall off like a house of cards https://www.github.com",
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
      server.enqueue(body: data);
      final posts = await source.getHomePosts(start: 200, limit: 10);
      expect(posts[0].linkPreview, isNot(null));
    });
  });
}
