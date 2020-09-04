import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'common.dart';

void main() {
  UserRepository repository;
  SetAuthenticationMethodUseCase setAuthenticationMethodUseCase;

  setUp(() {
    repository = UserRepositoryMock();
    setAuthenticationMethodUseCase = SetAuthenticationMethodUseCase(
      userRepository: repository,
    );
  });

  test('biometrics performs correct calls', () async {
    when(repository.saveAuthenticationMethod('address', any))
        .thenAnswer((_) => Future.value(null));

    await setAuthenticationMethodUseCase.biometrics('address');

    final authMethod = BiometricAuthentication();
    verify(repository.saveAuthenticationMethod('address', authMethod))
        .called(1);
  });

  test('password performs the correct calls', () async {
    when(repository.saveAuthenticationMethod('address', any))
        .thenAnswer((_) => Future.value(null));

    await setAuthenticationMethodUseCase.password('address', 'password');

    final authMethod = PasswordAuthentication(
      hashedPassword:
          '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8',
    );
    verify(repository.saveAuthenticationMethod('address', authMethod))
        .called(1);
  });
}
