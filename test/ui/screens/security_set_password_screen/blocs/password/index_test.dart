import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/screens/security_set_password_screen/blocs/export.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';

import '../../../../../mocks/mocks.dart';

class MockRecoverAccountBloc extends Mock implements RecoverAccountBloc {}

class MockAccountBloc extends Mock implements AccountBloc {}

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockSaveWalletUseCase extends Mock implements SaveWalletUseCase {}

class MockSetAuthenticationMethodUseCase extends Mock
    implements SetAuthenticationMethodUseCase {}

void main() {
  MockAccountBloc mockAccountBloc;
  MockRecoverAccountBloc mockRecoverAccountBloc;
  MockLoginUseCase mockLoginUseCase;
  MockSetAuthenticationMethodUseCase mockSetAuthenticationMethodUseCase;
  MockSaveWalletUseCase mockSaveWalletUseCase;
  final mockWallet = MockWallet();

  setUp(() {
    mockAccountBloc = MockAccountBloc();
    mockRecoverAccountBloc = MockRecoverAccountBloc();
    mockLoginUseCase = MockLoginUseCase();
    mockSetAuthenticationMethodUseCase = MockSetAuthenticationMethodUseCase();
    mockSaveWalletUseCase = MockSaveWalletUseCase();
  });

  group(
    'RestoreBackupBloc',
    () {
      SetPasswordBloc setPasswordBloc;
      var userAccount = MooncakeAccount(
        profilePicUri: 'https://example.com/avatar.png',
        moniker: 'john-doe',
        cosmosAccount: cosmosAccount,
      );
      setUp(
        () {
          setPasswordBloc = SetPasswordBloc(
            accountBloc: mockAccountBloc,
            recoverAccountBloc: mockRecoverAccountBloc,
            loginUseCase: mockLoginUseCase,
            setAuthenticationMethodUseCase: mockSetAuthenticationMethodUseCase,
            saveWalletUseCase: mockSaveWalletUseCase,
          );
        },
      );

      blocTest(
        'PasswordChanged: work properly',
        build: () {
          return setPasswordBloc;
        },
        act: (bloc) async {
          bloc.add(PasswordChanged('password'));
        },
        expect: [
          SetPasswordState(
            showPassword: false,
            inputPassword: 'password',
            savingPassword: false,
          ),
        ],
      );

      blocTest(
        'PasswordChanged: work properly',
        build: () {
          return setPasswordBloc;
        },
        act: (bloc) async {
          bloc.add(TriggerPasswordVisibility());
          bloc.add(TriggerPasswordVisibility());
        },
        expect: [
          SetPasswordState(
            showPassword: true,
            inputPassword: '',
            savingPassword: false,
          ),
          SetPasswordState(
            showPassword: false,
            inputPassword: '',
            savingPassword: false,
          ),
        ],
      );

      blocTest(
        'SavePassword: work properly',
        build: () {
          return setPasswordBloc;
        },
        act: (bloc) async {
          when(mockRecoverAccountBloc.state)
              .thenAnswer((_) => RecoverAccountState.initial());
          when(mockAccountBloc.state)
              .thenReturn(LoggedIn.initial(userAccount, [userAccount]));
          when(mockSetAuthenticationMethodUseCase.password('address', any))
              .thenAnswer((_) => Future.value(null));
          when(mockLoginUseCase.login(any))
              .thenAnswer((_) => Future.value(null));
          when(mockSaveWalletUseCase.saveWallet(any))
              .thenAnswer((_) => Future.value(mockWallet));
          bloc.add(SavePassword());
        },
        expect: [
          SetPasswordState(
            showPassword: false,
            inputPassword: '',
            savingPassword: true,
          ),
        ],
      );
    },
  );
}
