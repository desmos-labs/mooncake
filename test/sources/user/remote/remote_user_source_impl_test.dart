import 'dart:convert';
import 'dart:io';

import 'package:mooncake/entities/account/export.dart';
import 'package:test/test.dart';
import 'package:mock_web_server/mock_web_server.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/sources/sources.dart';

class ChainHelperMock extends Mock implements ChainHelper {}

void main() {
  MockWebServer server;
  ChainHelperMock chainHelper;
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

    source = RemoteUserSourceImpl(
      chainHelper: chainHelper,
      faucetEndpoint: server.url,
    );
  });

  test('getAccountData returns null when response is wrong', () async {
    final response = LcdResponse(height: "1", result: {});
    server.enqueue(body: jsonEncode(response.toJson()));

    expect(await source.getAccount(""), isNull);
  });

  test('getAccountData returns valid data with correct response', () async {
    final file = File("test_resources/account/account_response.json");
    final json = jsonDecode(file.readAsStringSync());
    final accountResponse = LcdResponse.fromJson(json);
    server.enqueue(body: jsonEncode(accountResponse));

    final account = await source
        .getAccount("desmos16f9wz7yg44pjfhxyn22kycs0qjy778ng877usl");
    expect(account, isNotNull);
    expect(account.cosmosAccount.address,
        "desmos16f9wz7yg44pjfhxyn22kycs0qjy778ng877usl");
    expect(account.cosmosAccount.sequence, 39);
    expect(account.cosmosAccount.accountNumber, 54);
    expect(account.cosmosAccount.coins,
        [StdCoin(amount: "10000000", denom: "udaric")]);
  });

  test('fundAccount completes successfully when no exception', () async {
    final account = MooncakeAccount.local("address");
    server.dispatcher = (HttpRequest request) async {
      expect(request.method, "POST");
      expect(
        request.headers.value("Content-Type"),
        contains("application/json"),
      );
      expect(request.contentLength, greaterThan(0));

      return MockResponse()
        ..httpCode = 200
        ..body = "Ok";
    };

    expect(source.fundAccount(account), completes);
  });
}
