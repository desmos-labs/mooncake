import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'common.dart';

void main() {
  UserRepository repository;
  RefreshAccountUseCase refreshAccountUseCase;

  setUp(() {
    repository = UserRepositoryMock();
    refreshAccountUseCase = RefreshAccountUseCase(userRepository: repository);
  });

  test('refresh performs correct calls', () async {
    when(repository.refreshAccount('address'))
        .thenAnswer((_) => Future.value(null));

    await refreshAccountUseCase.refresh('address');

    verify(repository.refreshAccount('address')).called(1);
  });
}
