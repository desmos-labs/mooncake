import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:mockito/mockito.dart';
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
        build: () async {
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
    },
  );
}
