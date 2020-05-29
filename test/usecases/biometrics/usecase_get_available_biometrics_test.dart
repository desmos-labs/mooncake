import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'common.dart';

void main() {
  LocalAuthentication localAuthentication;
  GetAvailableBiometricsUseCase getAvailableBiometricsUseCase;

  setUp(() {
    localAuthentication = LocalAuthenticationMock();
    getAvailableBiometricsUseCase = GetAvailableBiometricsUseCase(
      localAuthentication: localAuthentication,
    );
  });

  test('get performs correct call', () async {
    final authMethods = [BiometricType.face, BiometricType.fingerprint];
    when(localAuthentication.getAvailableBiometrics())
        .thenAnswer((_) => Future.value(authMethods));

    final result = await getAvailableBiometricsUseCase.get();
    expect(result, equals(authMethods));

    verify(localAuthentication.getAvailableBiometrics()).called(1);
  });
}
