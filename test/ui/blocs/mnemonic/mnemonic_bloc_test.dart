import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:mooncake/ui/ui.dart';

class MockNavigatorBloc extends Mock implements NavigatorBloc {}

class MockGetMnemonicUseCase extends Mock implements GetMnemonicUseCase {}

class MockEncryptMnemonicUseCase extends Mock
    implements EncryptMnemonicUseCase {}

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

void main() {
  MockNavigatorBloc mockNavigatorBloc;
  MockGetMnemonicUseCase mockGetMnemonicUseCase;
  MockEncryptMnemonicUseCase mockEncryptMnemonicUseCase;
  MockFirebaseAnalytics mockFirebaseAnalytics;

  setUp(() {
    mockNavigatorBloc = MockNavigatorBloc();
    mockGetMnemonicUseCase = MockGetMnemonicUseCase();
    mockEncryptMnemonicUseCase = MockEncryptMnemonicUseCase();
    mockFirebaseAnalytics = MockFirebaseAnalytics();
  });

  group(
    'MnemonicBloc',
    () {
      MnemonicBloc mnemonicBloc;
      var mnemonic = <String>['first', 'second', 'third'];
      setUp(
        () {
          mnemonicBloc = MnemonicBloc(
            navigatorBloc: mockNavigatorBloc,
            getMnemonicUseCase: mockGetMnemonicUseCase,
            encryptMnemonicUseCase: mockEncryptMnemonicUseCase,
            analytics: mockFirebaseAnalytics,
          );
        },
      );

      blocTest(
        'ToggleCheckBox: correctly updates tab',
        build: () {
          return mnemonicBloc;
        },
        act: (bloc) async {
          bloc.add(ToggleCheckBox());
          bloc.add(ToggleCheckBox());
          bloc.add(ToggleCheckBox());
        },
        expect: [
          MnemonicState(
            hasCheckedBox: true,
            showMnemonic: false,
            mnemonic: [],
          ),
          MnemonicState(
            hasCheckedBox: false,
            showMnemonic: false,
            mnemonic: [],
          ),
          MnemonicState(
            hasCheckedBox: true,
            showMnemonic: false,
            mnemonic: [],
          ),
        ],
      );

      blocTest(
        'ShowMnemonic: correctly updates tab',
        build: () {
          when(mockGetMnemonicUseCase.get('address')).thenAnswer((_) {
            return Future.value(mnemonic);
          });
          return mnemonicBloc;
        },
        act: (bloc) async {
          bloc.add(ShowMnemonic('address'));
        },
        expect: [
          MnemonicState(
            hasCheckedBox: false,
            showMnemonic: true,
            mnemonic: mnemonic,
          ),
        ],
      );

      blocTest(
        'ShowExportPopup: correctly updates tab',
        build: () {
          return mnemonicBloc;
        },
        act: (bloc) async {
          bloc.add(ShowExportPopup());
        },
        expect: [
          ExportingMnemonic(
            encryptPassword: null,
            exportingMnemonic: false,
            hasCheckedBox: false,
            showMnemonic: false,
            mnemonic: [],
          ),
        ],
      );

      blocTest(
        'ChangeEncryptPassword: correctly updates tab',
        build: () {
          return mnemonicBloc;
        },
        act: (bloc) async {
          bloc.add(ShowExportPopup());
          bloc.add(ChangeEncryptPassword('123456'));
        },
        skip: 1,
        expect: [
          ExportingMnemonic(
            encryptPassword: '123456',
            exportingMnemonic: false,
            hasCheckedBox: false,
            showMnemonic: false,
            mnemonic: [],
          ),
        ],
      );

      blocTest(
        'CloseExportPopup: correctly updates tab',
        build: () {
          return mnemonicBloc;
        },
        act: (bloc) async {
          bloc.add(CloseExportPopup());
        },
        skip: 1,
        expect: [],
      );

      blocTest(
        'ExportMnemonic: correctly updates tab',
        build: () {
          when(mockEncryptMnemonicUseCase.encrypt(any, any)).thenAnswer((_) {
            return Future.value(MnemonicData(
              ivBase64: 'null',
              encryptedMnemonicBase64: 'null',
            ));
          });
          return mnemonicBloc;
        },
        act: (bloc) async {
          bloc.add(ShowExportPopup());
          bloc.add(ExportMnemonic());
        },
        skip: 1,
        expect: [
          ExportingMnemonic(
            encryptPassword: null,
            exportingMnemonic: true,
            hasCheckedBox: false,
            showMnemonic: false,
            mnemonic: [],
          ),
          MnemonicState(
            hasCheckedBox: false,
            showMnemonic: false,
            mnemonic: [],
          )
        ],
      );
    },
  );
}
