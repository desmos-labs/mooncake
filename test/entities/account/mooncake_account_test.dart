import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:test/test.dart';

void main() {
  final account = MooncakeAccount(
    profilePicUri: 'https://api.adorable.io/avatars/285/random.png',
    moniker: 'random',
    cosmosAccount: CosmosAccount(
      address: 'desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r',
      accountNumber: '0',
      sequence: '0',
      coins: [StdCoin(denom: 'desmos', amount: '100000')],
    ),
  );

  test('toJson and fromJson', () {
    final json = account.toJson();
    final fromJson = MooncakeAccount.fromJson(json);
    expect(fromJson, equals(account));
  });

  group('needsFunding', () {
    test('returns true with no tokens', () {
      final emptyCoinsAccount = account.copyWith(
        cosmosAccount: account.cosmosAccount.copyWith(coins: []),
      );
      expect(emptyCoinsAccount.needsFunding, isTrue);
    });

    test('returns true with no fee tokens but other tokens', () {
      final accountWithOtherTokens = account.copyWith(
        cosmosAccount: account.cosmosAccount.copyWith(coins: [
          StdCoin(denom: 'token', amount: '10000'),
        ]),
      );
      expect(accountWithOtherTokens.needsFunding, isTrue);
    });

    test('returns true with 0 fee tokens', () {
      final accountWithNoFeeTokens = account.copyWith(
        cosmosAccount: account.cosmosAccount.copyWith(coins: [
          StdCoin(denom: Constants.FEE_TOKEN, amount: '0'),
        ]),
      );
      expect(accountWithNoFeeTokens.needsFunding, isTrue);
    });

    test('returns false with 1 fee token', () {
      final accountWithOneFeeToken = account.copyWith(
        cosmosAccount: account.cosmosAccount.copyWith(coins: [
          StdCoin(denom: Constants.FEE_TOKEN, amount: '1'),
        ]),
      );
      expect(accountWithOneFeeToken.needsFunding, isFalse);
    });
  });

  test('screenName', () {
    final accountWithUsername = account.copyWith(moniker: 'desmos');
    expect(accountWithUsername.screenName, equals('desmos'));

    final accountWithoutUsername = account.copyWith(moniker: '');
    expect(accountWithoutUsername.screenName, equals('desmos12rh...2yf0r'));
  });
}
