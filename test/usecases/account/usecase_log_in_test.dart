import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

import '../../mocks/mocks.dart';
import 'common.dart';

void main() {
  UserRepository repository;
  LoginUseCase loginUseCase;

  setUp(() {
    repository = UserRepositoryMock();
    loginUseCase = LoginUseCase(userRepository: repository);
  });

  group('login works properly', () {
    test('when no funding is necessary', () async {
      final wallet = MockWallet();
      final account = MooncakeAccount.local('address').copyWith(
        cosmosAccount: CosmosAccount(
          sequence: '0',
          accountNumber: '0',
          address: 'address',
          coins: [StdCoin(denom: Constants.FEE_TOKEN, amount: '10000')],
        ),
      );
      when(repository.refreshAccount(account.address))
          .thenAnswer((_) => Future.value(account));

      await loginUseCase.login(wallet);

      verifyInOrder([
        repository.refreshAccount(account.address),
      ]);
      verifyNever(repository.fundAccount(any));
    });

    test('when funding is required', () async {
      final wallet = MockWallet();
      final account = MooncakeAccount.local('address');
      when(repository.saveWallet(any)).thenAnswer((_) => Future.value(wallet));
      when(repository.refreshAccount(account.address))
          .thenAnswer((_) => Future.value(account));
      when(repository.fundAccount(any)).thenAnswer((_) => Future.value(null));

      await loginUseCase.login(wallet);

      verifyInOrder([
        repository.refreshAccount(account.address),
        repository.fundAccount(account),
      ]);
    });
  });
}
