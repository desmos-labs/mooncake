import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:mooncake/entities/account/export.dart';
import 'package:mooncake/ui/ui.dart';

class MockGenerateMnemonicUseCase extends Mock
    implements GenerateMnemonicUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockGetAccountUseCase extends Mock implements GetAccountUseCase {}

class MockRefreshAccountUseCase extends Mock implements RefreshAccountUseCase {}

class MockGetSettingUseCase extends Mock implements GetSettingUseCase {}

class MockSaveSettingUseCase extends Mock implements SaveSettingUseCase {}

class MockNavigatorBloc extends Mock implements NavigatorBloc {}

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

void main() {
  MockGenerateMnemonicUseCase mockGenerateMnemonicUseCase;
  MockLogoutUseCase mockLogoutUseCase;
  MockGetAccountUseCase mockGetAccountUseCase;
  MockRefreshAccountUseCase mockRefreshAccountUseCase;
  MockGetSettingUseCase mockGetSettingUseCase;
  MockSaveSettingUseCase mockSaveSettingUseCase;
  MockNavigatorBloc mockNavigatorBloc;
  MockFirebaseAnalytics mockFirebaseAnalytics;

  setUp(() {
    mockGenerateMnemonicUseCase = MockGenerateMnemonicUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockGetAccountUseCase = MockGetAccountUseCase();
    mockRefreshAccountUseCase = MockRefreshAccountUseCase();
    mockGetSettingUseCase = MockGetSettingUseCase();
    mockSaveSettingUseCase = MockSaveSettingUseCase();
    mockNavigatorBloc = MockNavigatorBloc();
    mockFirebaseAnalytics = MockFirebaseAnalytics();
  });

  group('AccountBloc', () {
    AccountBloc accountBloc;

    setUp(() {
      final controller = StreamController<MooncakeAccount>();
      when(mockGetAccountUseCase.stream()).thenAnswer((_) => controller.stream);
      accountBloc = AccountBloc(
        generateMnemonicUseCase: mockGenerateMnemonicUseCase,
        logoutUseCase: mockLogoutUseCase,
        getUserUseCase: mockGetAccountUseCase,
        refreshAccountUseCase: mockRefreshAccountUseCase,
        getSettingUseCase: mockGetSettingUseCase,
        saveSettingUseCase: mockSaveSettingUseCase,
        navigatorBloc: mockNavigatorBloc,
        analytics: mockFirebaseAnalytics,
      );
    });

    test(
      'Expect initial state to be loading',
      () {
        expect(accountBloc.state.toString(), 'Loading');
      },
    );

    test(
      'Expect check status event to return loggedout state',
      () async {
        when(mockGetSettingUseCase.get(key: anyNamed("key"))).thenAnswer((_) {
          return Future.value(null);
        });
        when(mockGetAccountUseCase.single()).thenAnswer((_) {
          return Future.value(null);
        });

        accountBloc.add(CheckStatus());
        await emitsExactly(accountBloc, [LoggedOut()]);
        verify(mockGetAccountUseCase.single()).called(1);
        verify(mockGetSettingUseCase.get(key: anyNamed("key"))).called(1);
      },
    );

    // blocTest(
    //   'Expect check status event to return loggedout state',
    //   // ignore: return_of_invalid_type_from_closure
    //   build: () => accountBloc,
    //   act: (bloc) => bloc.add(CheckStatus()),
    //   expect: [1],
    // );
  });
}
