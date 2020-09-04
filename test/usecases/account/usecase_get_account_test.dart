import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/account/export.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'common.dart';

void main() {
  UserRepository repository;
  GetAccountUseCase getAccountUseCase;

  setUp(() {
    repository = UserRepositoryMock();
    getAccountUseCase = GetAccountUseCase(userRepository: repository);
  });

  test('single performs correct calls', () async {
    final account = MooncakeAccount.local('address');
    when(repository.getAccount(account.address))
        .thenAnswer((_) => Future.value(account));

    final result = await getAccountUseCase.single(account.address);
    expect(result, equals(account));

    verify(repository.getAccount(account.address)).called(1);
  });
}
