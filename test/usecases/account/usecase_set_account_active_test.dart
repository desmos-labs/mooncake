import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/account/export.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'common.dart';

void main() {
  UserRepository repository;
  SetAccountActiveUsecase setAccountActiveUsecase;

  setUp(() {
    repository = UserRepositoryMock();
    setAccountActiveUsecase =
        SetAccountActiveUsecase(userRepository: repository);
  });

  test('setActive performs correct calls', () async {
    when(repository.setActiveAccount(any))
        .thenAnswer((_) => Future.value(null));

    final account = MooncakeAccount.local('address');
    await setAccountActiveUsecase.setActive(account);

    verify(repository.setActiveAccount(account)).called(1);
  });
}
