import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'common.dart';

void main() {
  UserRepository repository;
  LoginUseCase loginUseCase;

  setUp(() {
    repository = UserRepositoryMock();
    loginUseCase = LoginUseCase(userRepository: repository);
  });

  test('login works properly when no funding is necessary', () async {
    final account = MooncakeAccount.local("address").copyWith(
      cosmosAccount: CosmosAccount(
        sequence: 0,
        accountNumber: 0,
        address: "address",
        coins: [StdCoin(denom: Constants.FEE_TOKEN, amount: "10000")],
      ),
    );
    when(repository.saveWallet(any)).thenAnswer((_) => Future.value(null));
    when(repository.refreshAccount()).thenAnswer((_) => Future.value(account));

    final mnemonic = "mnemonic";
    await loginUseCase.login(mnemonic);

    verifyInOrder([
      repository.saveWallet(mnemonic),
      repository.refreshAccount(),
    ]);
    verifyNever(repository.fundAccount(any));
  });

  test('login works properly when funding is required', () async {
    final account = MooncakeAccount.local("address");
    when(repository.saveWallet(any)).thenAnswer((_) => Future.value(null));
    when(repository.refreshAccount()).thenAnswer((_) => Future.value(account));
    when(repository.fundAccount(any)).thenAnswer((_) => Future.value(null));

    final mnemonic = "mnemonic";
    await loginUseCase.login(mnemonic);

    verifyInOrder([
      repository.saveWallet(mnemonic),
      repository.refreshAccount(),
      repository.fundAccount(account),
    ]);
  });
}
