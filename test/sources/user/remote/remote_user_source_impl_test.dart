import 'dart:convert';
import 'dart:io';

import 'package:graphql/client.dart';
import 'package:mock_web_server/mock_web_server.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/account/export.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/sources/sources.dart';
import 'package:test/test.dart';

class GraphQlClientMock extends Mock implements GraphQLClient {}

class ChainHelperMock extends Mock implements ChainSource {}

class LocalUserSourceMock extends Mock implements LocalUserSource {}

class RemoteMediasSourceMock extends Mock implements RemoteMediasSource {}

void main() {
  MockWebServer server;
  GraphQlClientMock graphQlClient;
  ChainHelperMock chainHelper;
  LocalUserSourceMock userSourceMock;
  RemoteMediasSourceMock mediasSource;

  RemoteUserSourceImpl source;

  setUpAll(() {
    server = MockWebServer();
    server.start();
  });

  setUp(() {
    // Clean the dispatcher to avoid cross-testing conflicts
    server.dispatcher = null;

    chainHelper = ChainHelperMock();
    when(chainHelper.lcdEndpoint).thenReturn(server.url);

    graphQlClient = GraphQlClientMock();

    userSourceMock = LocalUserSourceMock();
    mediasSource = RemoteMediasSourceMock();

    source = RemoteUserSourceImpl(
      chainHelper: chainHelper,
      graphQLClient: graphQlClient,
      msgConverter: UserMsgConverter(),
      remoteMediasSource: mediasSource,
      userSource: userSourceMock,
    );
  });

  test('getAccountData returns null when response is wrong', () async {
    final response = LcdResponse(height: '1', result: {});
    server.enqueue(body: jsonEncode(response.toJson()));

    expect(await source.getAccount(''), isNull);
  });

  test('getAccountData returns valid data with correct response', () async {
    final file = File('test_resources/account/account_response.json');
    final json = jsonDecode(file.readAsStringSync());
    final accountResponse = LcdResponse.fromJson(json as Map<String, dynamic>);

    server.enqueue(body: jsonEncode(accountResponse));
    when(graphQlClient.query(any)).thenAnswer((_) => Future.value(QueryResult(
          source: QueryResultSource.Network,
          data: {
            'users': [
              User.fromAddress('desmos16f9wz7yg44pjfhxyn22kycs0qjy778ng877usl')
                  .toJson()
            ]
          },
        )));

    final account = await source
        .getAccount('desmos16f9wz7yg44pjfhxyn22kycs0qjy778ng877usl');
    expect(account, isNotNull);
    expect(account.cosmosAccount.address,
        'desmos16f9wz7yg44pjfhxyn22kycs0qjy778ng877usl');
    expect(account.cosmosAccount.sequence, '39');
    expect(account.cosmosAccount.accountNumber, '54');
    expect(account.cosmosAccount.coins,
        [StdCoin(amount: '10000000', denom: 'udaric')]);
  });

  test('fundAccount completes successfully when no exception', () async {
    final account = MooncakeAccount.local('address');
    server.dispatcher = (HttpRequest request) async {
      expect(request.method, 'POST');
      expect(
        request.headers.value('Content-Type'),
        contains('application/json'),
      );
      expect(request.contentLength, greaterThan(0));

      return MockResponse()
        ..httpCode = 200
        ..body = 'Ok';
    };

    expect(source.fundAccount(account), completes);
  });
}
