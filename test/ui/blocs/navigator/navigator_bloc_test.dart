import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:mooncake/ui/ui.dart';

class MockCheckLoginUseCase extends Mock implements CheckLoginUseCase {}

class MockCanUseBiometricsUseCase extends Mock
    implements CanUseBiometricsUseCase {}

class MockGetAuthenticationMethodUseCase extends Mock
    implements GetAuthenticationMethodUseCase {}

void main() {
  MockCheckLoginUseCase mockCheckLoginUseCase;
  MockCanUseBiometricsUseCase mockCanUseBiometricsUseCase;
  MockGetAuthenticationMethodUseCase mockGetAuthenticationMethodUseCase;

  setUp(() {
    mockCanUseBiometricsUseCase = MockCanUseBiometricsUseCase();
    mockCheckLoginUseCase = MockCheckLoginUseCase();
    mockGetAuthenticationMethodUseCase = MockGetAuthenticationMethodUseCase();
  });

  group(
    'NavigatorBloc',
    () {
      NavigatorBloc navigatorBloc;
      setUp(
        () {
          navigatorBloc = NavigatorBloc(
            checkLoginUseCase: mockCheckLoginUseCase,
            canUseBiometricsUseCase: mockCanUseBiometricsUseCase,
            getAuthenticationMethodUseCase: mockGetAuthenticationMethodUseCase,
          );
        },
      );

      blocTest(
        'Expect no streams return for any navigation event',
        build: () {
          return navigatorBloc;
        },
        act: (bloc) async {
          // hard to test dont have access to global variable
          // bloc.add(NavigateToHome());
          // bloc.add(NavigateToProtectAccount());
          // bloc.add(NavigateToRecoverAccount());
          // bloc.add(NavigateToEnableBiometrics());
          // bloc.add(NavigateToSetPassword());
          // bloc.add(NavigateToWallet());
          // bloc.add(NavigateToShowMnemonicAuth());
        },
        expect: [],
      );
    },
  );
}
