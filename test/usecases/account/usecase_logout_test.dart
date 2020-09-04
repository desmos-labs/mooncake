import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'common.dart';

void main() {
  UserRepository repository;
  LogoutUseCase logoutUseCase;

  setUp(() {
    repository = UserRepositoryMock();
    logoutUseCase = LogoutUseCase(userRepository: repository);
  });

  test('logout performs correct calls', () async {
    when(repository.logout('address')).thenAnswer((_) => Future.value(null));

    await logoutUseCase.logout('address');

    verify(repository.logout('address')).called(1);
  });

  test('logoutAll performs correct calls', () async {
    when(repository.deleteData()).thenAnswer((_) => Future.value(null));

    await logoutUseCase.logoutAll();

    verify(repository.deleteData()).called(1);
  });
}
