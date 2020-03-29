import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/entities/account/export.dart';
import 'package:mooncake/entities/entities.dart';

void main() {
  test('toJson and fromJson', () {
    final account = MooncakeAccount(
      avatarUrl: "https://api.adorable.io/avatars/285/random.png",
      username: "random",
      cosmosAccount: CosmosAccount(
        address: "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r",
        accountNumber: 0,
        sequence: 0,
        coins: [StdCoin(denom: "desmos", amount: "100000")],
      ),
    );
    final json = account.toJson();
    final fromJson = MooncakeAccount.fromJson(json);
    expect(fromJson, equals(account));
  });

  test('screenName', () {
    final accountWithUsername = MooncakeAccount(
      username: "desmos",
      avatarUrl: null,
      cosmosAccount: CosmosAccount.offline(
        "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r",
      ),
    );
    expect(accountWithUsername.screenName, equals("desmos"));

    final accountWithoutUsername = MooncakeAccount.local(
      "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r",
    );
    expect(
      accountWithoutUsername.screenName,
      equals("desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r"),
    );
  });
}
