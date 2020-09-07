import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/screens/restore_mnemonic_backup_screen/blocs/export.dart';

class MockNavigatorBloc extends Mock implements NavigatorBloc {}

class MockRecoverAccountBloc extends Mock implements RecoverAccountBloc {}

class MockDecryptMnemonicUseCase extends Mock
    implements DecryptMnemonicUseCase {}

void main() {
  MockNavigatorBloc mockNavigatorBloc;
  MockRecoverAccountBloc mockRecoverAccountBloc;
  MockDecryptMnemonicUseCase mockDecryptMnemonicUseCase;

  setUp(() {
    mockNavigatorBloc = MockNavigatorBloc();
    mockRecoverAccountBloc = MockRecoverAccountBloc();
    mockDecryptMnemonicUseCase = MockDecryptMnemonicUseCase();
  });

  group(
    'RestoreBackupBloc',
    () {
      RestoreBackupBloc restoreBackupBloc;
      setUp(
        () {
          restoreBackupBloc = RestoreBackupBloc(
            navigatorBloc: mockNavigatorBloc,
            recoverAccountBloc: mockRecoverAccountBloc,
            decryptMnemonicUseCase: mockDecryptMnemonicUseCase,
          );
        },
      );

      blocTest(
        'ResetForm: work properly',
        build: () {
          return restoreBackupBloc;
        },
        act: (bloc) async {
          bloc.add(BackupTextChanged('hello'));
        },
        expect: [
          RestoreBackupState(
            backup: 'hello',
            password: null,
            isPasswordValid: true,
            restoring: false,
          ),
        ],
      );

      blocTest(
        'EncryptPasswordChanged: work properly',
        build: () {
          return restoreBackupBloc;
        },
        act: (bloc) async {
          bloc.add(EncryptPasswordChanged('hello'));
        },
        expect: [
          RestoreBackupState(
            backup: null,
            password: 'hello',
            isPasswordValid: true,
            restoring: false,
          ),
        ],
      );

      // blocTest(
      //   'RestoreBackup: work properly',
      //   build: () {
      //     return restoreBackupBloc;
      //   },
      //   act: (bloc) async {
      //     when(mockDecryptMnemonicUseCase.decrypt(any, any))
      //         .thenAnswer((_) => Future.value(["a", "b", "c"]));

      //     bloc.add(BackupTextChanged("Aliquamscelerisquelaciniaoo0"));
      //     bloc.add(RestoreBackup());
      //   },
      //   skip: 1,
      //   expect: [
      //     RestoreBackupState(
      //       backup: null,
      //       password: null,
      //       isPasswordValid: true,
      //       restoring: true,
      //     ),
      //   ],
      // );
    },
  );
}
