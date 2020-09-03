import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/account/export.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'common.dart';

void main() {
  UserRepository repository;
  SaveAccountUseCase saveAccountUseCase;

  setUp(() {
    repository = UserRepositoryMock();
    saveAccountUseCase = SaveAccountUseCase(userRepository: repository);
  });

  test('save performs correct calls', () async {
    when(repository.saveAccount(any)).thenAnswer((_) => Future.value(null));

    final account = MooncakeAccount.local('address');
    await saveAccountUseCase.save(account);

    verify(repository.saveAccount(account)).called(1);
  });
}
