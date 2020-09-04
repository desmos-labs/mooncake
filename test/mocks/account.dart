import 'package:alan/alan.dart';
import 'package:mockito/mockito.dart';

final CosmosAccount cosmosAccount = CosmosAccount(
  accountNumber: '153',
  sequence: '45',
  address: 'desmos1ew60ztvqxlf5kjjyyzxf7hummlwdadgesu3725',
  coins: [
    StdCoin(amount: '10000', denom: 'udaric'),
  ],
);

// ignore: must_be_immutable
class MockWallet extends Mock implements Wallet {
  @override
  String get bech32Address => 'address';
}
