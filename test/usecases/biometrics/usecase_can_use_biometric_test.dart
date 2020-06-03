import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'common.dart';

void main() {
  LocalAuthentication localAuthentication;
  CanUseBiometricsUseCase canUseBiometricsUseCase;

  setUp(() {
    localAuthentication = LocalAuthenticationMock();
    canUseBiometricsUseCase = CanUseBiometricsUseCase(
      localAuthentication: localAuthentication,
    );
  });

  test('check performs correct calls', () async {
    final canUseBio = true;
    when(localAuthentication.canCheckBiometrics)
        .thenAnswer((_) => Future.value(canUseBio));

    final result = await canUseBiometricsUseCase.check();
    expect(result, equals(canUseBio));

    verify(localAuthentication.canCheckBiometrics).called(1);
  });
}
