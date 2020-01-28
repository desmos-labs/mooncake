import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/sources/sources.dart';

class ChainHelperMock extends Mock implements ChainHelper {}

void main() {
  ChainHelperMock chainHelper;
  RemoteUserSourceImpl source;

  setUp(() {
    chainHelper = ChainHelperMock();
    source = RemoteUserSourceImpl(chainHelper: chainHelper);
  });

  group('getAccountData', () {
    test('getAccountData returns null when response is wrong', () async {
      final response = LcdResponse(height: "1", result: {});
      when(chainHelper.queryChain(any))
          .thenAnswer((_) => Future.value(response));

      expect(await source.getAccountData(""), isNull);
    });

    test('getAccountData returns valid data with correct response', () async {
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
}
