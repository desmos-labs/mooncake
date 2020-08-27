import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/screens/security_set_biometrics_screen/blocs/export.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';

import '../../../../../mocks/mocks.dart';

class MockAccountBloc extends Mock implements AccountBloc {}

class MockRecoverAccountBloc extends Mock implements RecoverAccountBloc {}

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockGetAvailableBiometricsUseCase extends Mock
    implements GetAvailableBiometricsUseCase {}

class MockSetAuthenticationMethodUseCase extends Mock
    implements SetAuthenticationMethodUseCase {}

void main() {
  MockAccountBloc mockAccountBloc;
  MockRecoverAccountBloc mockRecoverAccountBloc;
  MockLoginUseCase mockLoginUseCase;
  MockGetAvailableBiometricsUseCase mockGetAvailableBiometricsUseCase;
  MockSetAuthenticationMethodUseCase mockSetAuthenticationMethodUseCase;

  setUp(() {
    mockAccountBloc = MockAccountBloc();
    mockRecoverAccountBloc = MockRecoverAccountBloc();
    mockLoginUseCase = MockLoginUseCase();
    mockGetAvailableBiometricsUseCase = MockGetAvailableBiometricsUseCase();
    mockSetAuthenticationMethodUseCase = MockSetAuthenticationMethodUseCase();
  });

  group(
    'RestoreBackupBloc',
    () {
      BiometricsBloc biometricsBloc;
      setUp(
        () {
          biometricsBloc = BiometricsBloc(
            accountBloc: mockAccountBloc,
            recoverAccountBloc: mockRecoverAccountBloc,
            loginUseCase: mockLoginUseCase,
            getAvailableBiometricsUseCase: mockGetAvailableBiometricsUseCase,
            setAuthenticationMethodUseCase: mockSetAuthenticationMethodUseCase,
          );
        },
      );

      blocTest(
        'AuthenticateWithBiometrics: work properly',
        build: () async {
          return biometricsBloc;
        },
        act: (bloc) async {
          MooncakeAccount userAccount = MooncakeAccount(
            profilePicUri: "https://example.com/avatar.png",
            moniker: "john-doe",
            cosmosAccount: cosmosAccount,
          );
          when(mockSetAuthenticationMethodUseCase.biometrics("address"))
              .thenAnswer((_) => Future.value(null));
          when(mockRecoverAccountBloc.state)
              .thenAnswer((_) => RecoverAccountState.initial());
          when(mockAccountBloc.state).thenReturn(LoggedIn.initial(userAccount));
          when(mockLoginUseCase.login(any))
              .thenAnswer((_) => Future.value(null));
          bloc.add(AuthenticateWithBiometrics("address"));
        },
        expect: [
          BiometricsState(
            saving: true,
            availableBiometric: BiometricType.fingerprint,
          ),
        ],
      );

      blocTest(
        'CheckAuthenticationType: work properly',
        build: () async {
          return biometricsBloc;
        },
        act: (bloc) async {
          when(mockGetAvailableBiometricsUseCase.get())
              .thenAnswer((_) => Future.value([BiometricType.face]));
          bloc.add(CheckAuthenticationType());
        },
        expect: [
          BiometricsState(
            saving: false,
            availableBiometric: BiometricType.face,
          ),
        ],
      );
    },
  );
}
