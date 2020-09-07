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

class MockSaveWalletUseCase extends Mock implements SaveWalletUseCase {}

void main() {
  MockAccountBloc mockAccountBloc;
  MockRecoverAccountBloc mockRecoverAccountBloc;
  MockLoginUseCase mockLoginUseCase;
  MockGetAvailableBiometricsUseCase mockGetAvailableBiometricsUseCase;
  MockSetAuthenticationMethodUseCase mockSetAuthenticationMethodUseCase;
  MockSaveWalletUseCase mockSaveWalletUseCase;
  final mockWallet = MockWallet();
  setUp(() {
    mockAccountBloc = MockAccountBloc();
    mockRecoverAccountBloc = MockRecoverAccountBloc();
    mockLoginUseCase = MockLoginUseCase();
    mockGetAvailableBiometricsUseCase = MockGetAvailableBiometricsUseCase();
    mockSetAuthenticationMethodUseCase = MockSetAuthenticationMethodUseCase();
    mockSaveWalletUseCase = MockSaveWalletUseCase();
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
            saveWalletUseCase: mockSaveWalletUseCase,
          );
        },
      );

      blocTest(
        'AuthenticateWithBiometrics: work properly',
        build: () {
          return biometricsBloc;
        },
        act: (bloc) async {
          var userAccount = MooncakeAccount(
            profilePicUri: 'https://example.com/avatar.png',
            moniker: 'john-doe',
            cosmosAccount: cosmosAccount,
          );
          when(mockSetAuthenticationMethodUseCase.biometrics('address'))
              .thenAnswer((_) => Future.value(null));
          when(mockRecoverAccountBloc.state)
              .thenAnswer((_) => RecoverAccountState.initial());
          when(mockAccountBloc.state)
              .thenReturn(LoggedIn.initial(userAccount, [userAccount]));
          when(mockLoginUseCase.login(any))
              .thenAnswer((_) => Future.value(null));
          when(mockSaveWalletUseCase.saveWallet(any))
              .thenAnswer((_) => Future.value(mockWallet));
          bloc.add(AuthenticateWithBiometrics());
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
        build: () {
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
