import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/account/authentication_method.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'common.dart';

void main() {
  UserRepository repository;
  GetAuthenticationMethodUseCase getAuthenticationMethodUseCase;

  setUp(() {
    repository = UserRepositoryMock();
    getAuthenticationMethodUseCase = GetAuthenticationMethodUseCase(
      userRepository: repository,
    );
  });

  test('get performs proper calls', () async {
    final authMethod = PasswordAuthentication(hashedPassword: 'password');
    when(repository.getAuthenticationMethod('address'))
        .thenAnswer((_) => Future.value(authMethod));

    final result = await getAuthenticationMethodUseCase.get('address');
    expect(result, equals(authMethod));

    verify(repository.getAuthenticationMethod('address')).called(1);
  });
}
