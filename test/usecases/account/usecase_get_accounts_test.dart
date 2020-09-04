import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/account/export.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'common.dart';

void main() {
  UserRepository repository;
  GetAccountsUseCase usecase;

  setUp(() {
    repository = UserRepositoryMock();
    usecase = GetAccountsUseCase(userRepository: repository);
  });

  test('all performs correct calls', () async {
    final account = MooncakeAccount.local('address');
    when(repository.getAccounts()).thenAnswer((_) => Future.value([account]));

    final result = await usecase.all();
    expect(result, equals([account]));

    verify(repository.getAccounts()).called(1);
  });
}
