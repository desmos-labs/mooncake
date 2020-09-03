import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'common.dart';

void main() {
  UserRepository repository;
  CheckLoginUseCase checkLoginUseCase;

  setUp(() {
    repository = UserRepositoryMock();
    checkLoginUseCase = CheckLoginUseCase(userRepository: repository);
  });

  test('isLoggedIn returns true when the account exists', () async {
    final account = MooncakeAccount.local('address');
    when(repository.getActiveAccount())
        .thenAnswer((_) => Future.value(account));

    expect(await checkLoginUseCase.isLoggedIn(), isTrue);
    verify(repository.getActiveAccount()).called(1);
  });
}
