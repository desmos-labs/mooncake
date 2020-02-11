import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
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
    source = RemoteUserSourceImpl(
      chainHelper: chainHelper,
      faucetEndpoint: server.url,
    );
  });

  group('getAccountData', () {
    test('returns null when response is wrong', () async {
      final response = LcdResponse(height: "1", result: {});
      when(chainHelper.queryChain(any))
          .thenAnswer((_) => Future.value(response));

      expect(await source.getAccountData(""), isNull);
    });

    test('returns valid data with correct response', () async {
      final file = File("test_resources/account/account_response.json");
      final json = jsonDecode(file.readAsStringSync());
      final accountResponse = LcdResponse.fromJson(json);
      when(chainHelper.queryChain(any))
          .thenAnswer((_) => Future.value(accountResponse));

      final account = await source.getAccountData("");
      expect(account, isNotNull);
      expect(account.address, "desmos16f9wz7yg44pjfhxyn22kycs0qjy778ng877usl");
      expect(account.sequence, "39");
      expect(account.accountNumber, "54");
      expect(account.coins, [StdCoin(amount: "10000000", denom: "udaric")]);
    });
  });

  group('fundAccount', () {
    final account = AccountData(
      address: "address",
      sequence: "0",
      accountNumber: "0",
      coins: [],
    );

    test('completes successfully if no exception is thrown', () async {
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
  });
}
