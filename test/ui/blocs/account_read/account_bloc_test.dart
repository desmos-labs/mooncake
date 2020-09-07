import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';

import '../../../mocks/mocks.dart';

class MockGenerateMnemonicUseCase extends Mock
    implements GenerateMnemonicUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockGetActiveAccountUseCase extends Mock
    implements GetActiveAccountUseCase {}

class MockRefreshAccountUseCase extends Mock implements RefreshAccountUseCase {}

class MockGetSettingUseCase extends Mock implements GetSettingUseCase {}

class MockSaveSettingUseCase extends Mock implements SaveSettingUseCase {}

class MockNavigatorBloc extends Mock implements NavigatorBloc {}

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

class MockGetAccountsUseCase extends Mock implements GetAccountsUseCase {}

class MockSetAccountActiveUsecase extends Mock
    implements SetAccountActiveUsecase {}

void main() {
  MockGenerateMnemonicUseCase mockGenerateMnemonicUseCase;
  MockLogoutUseCase mockLogoutUseCase;
  MockGetActiveAccountUseCase mockGetActiveAccountUseCase;
  MockRefreshAccountUseCase mockRefreshAccountUseCase;
  MockGetSettingUseCase mockGetSettingUseCase;
  MockSaveSettingUseCase mockSaveSettingUseCase;
  MockNavigatorBloc mockNavigatorBloc;
  MockFirebaseAnalytics mockFirebaseAnalytics;
  MockGetAccountsUseCase mockGetAccountsUseCase;
  MockSetAccountActiveUsecase mockSetAccountActiveUsecase;

  setUp(() {
    mockGenerateMnemonicUseCase = MockGenerateMnemonicUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockGetActiveAccountUseCase = MockGetActiveAccountUseCase();
    mockRefreshAccountUseCase = MockRefreshAccountUseCase();
    mockGetSettingUseCase = MockGetSettingUseCase();
    mockSaveSettingUseCase = MockSaveSettingUseCase();
    mockNavigatorBloc = MockNavigatorBloc();
    mockFirebaseAnalytics = MockFirebaseAnalytics();
    mockGetAccountsUseCase = MockGetAccountsUseCase();
    mockSetAccountActiveUsecase = MockSetAccountActiveUsecase();
  });

  group(
    'AccountBloc',
    () {
      AccountBloc accountBloc;
      var userAccount = MooncakeAccount(
        profilePicUri: 'https://example.com/avatar.png',
        moniker: 'john-doe',
        cosmosAccount: cosmosAccount,
      );
      var userAccountTwo = MooncakeAccount(
        profilePicUri: 'https://example.com/avatar.png',
        moniker: 'john-doe',
        cosmosAccount: cosmosAccount.copyWith(address: 'another address'),
      );
      const mnemonic = <String>[
        'frown',
        'spike',
        'buyer',
        'diagram',
        'between',
        'output',
        'keep',
        'ask',
        'column',
        'wage',
        'kid',
        'layer',
        'nasty',
        'grab',
        'learn',
        'same',
        'morning',
        'fog',
        'mandate',
        'sphere',
        'cream',
        'focus',
        'sister',
        'lava'
      ];

      setUp(
        () {
          final controller = StreamController<MooncakeAccount>();
          when(mockGetActiveAccountUseCase.stream())
              .thenAnswer((_) => controller.stream);
          accountBloc = AccountBloc(
            generateMnemonicUseCase: mockGenerateMnemonicUseCase,
            logoutUseCase: mockLogoutUseCase,
            getActiveAccountUseCase: mockGetActiveAccountUseCase,
            refreshAccountUseCase: mockRefreshAccountUseCase,
            getSettingUseCase: mockGetSettingUseCase,
            saveSettingUseCase: mockSaveSettingUseCase,
            navigatorBloc: mockNavigatorBloc,
            analytics: mockFirebaseAnalytics,
            getAccountsUseCase: mockGetAccountsUseCase,
            setAccountActiveUsecase: mockSetAccountActiveUsecase,
          );
        },
      );

      blocTest(
        'CheckStatus: Expect check status event to return loggedout state',
        build: () {
          when(mockGetSettingUseCase.get(key: anyNamed('key'))).thenAnswer((_) {
            return Future.value(null);
          });
          when(mockGetActiveAccountUseCase.single()).thenAnswer((_) {
            return Future.value(null);
          });
          return accountBloc;
        },
        act: (bloc) async => bloc.add(CheckStatus()),
        expect: [LoggedOut()],
        verify: (_) async {
          verify(mockGetActiveAccountUseCase.single()).called(1);
          verify(mockGetSettingUseCase.get(key: anyNamed('key'))).called(1);
        },
      );

      blocTest(
        'CheckStatus: Expect check status event to return loggedIn state',
        build: () {
          when(mockGetSettingUseCase.get(key: anyNamed('key'))).thenAnswer((_) {
            return Future.value(null);
          });
          when(mockGetActiveAccountUseCase.single()).thenAnswer((_) {
            return Future.value(userAccount);
          });

          when(mockGetAccountsUseCase.all()).thenAnswer((_) {
            return Future.value([userAccount]);
          });

          return accountBloc;
        },
        act: (bloc) async => bloc.add(CheckStatus()),
        expect: [
          LoggedIn.initial(userAccount, [userAccount])
        ],
        verify: (_) async {
          verify(mockGetAccountsUseCase.all()).called(1);
        },
      );

      blocTest(
        'GenerateAccount: to work properly',
        build: () {
          when(mockGenerateMnemonicUseCase.generate()).thenAnswer((_) {
            return Future.value(mnemonic);
          });
          return accountBloc;
        },
        act: (bloc) async => bloc.add(GenerateAccount()),
        expect: [CreatingAccount(), AccountCreated(mnemonic)],
      );

      blocTest(
        'GenerateAccountWhileLoggedIn: to work properly',
        build: () {
          when(mockGetActiveAccountUseCase.single()).thenAnswer((_) {
            return Future.value(userAccount);
          });
          when(mockGetAccountsUseCase.all()).thenAnswer((_) {
            return Future.value([userAccount]);
          });
          when(mockGenerateMnemonicUseCase.generate()).thenAnswer((_) {
            return Future.value(mnemonic);
          });
          return accountBloc;
        },
        act: (bloc) async {
          bloc.add(LogIn());
          bloc.add(GenerateAccountWhileLoggedIn());
        },
        skip: 1,
        expect: [
          CreatingAccountWhileLoggedIn(
              user: userAccount, accounts: [userAccount], refreshing: false),
          AccountCreatedWhileLoggedIn(
            mnemonic,
            accounts: [userAccount],
            user: userAccount,
            refreshing: false,
          ),
        ],
      );

      blocTest(
        'LogIn: to work properly',
        build: () {
          when(mockGetActiveAccountUseCase.single()).thenAnswer((_) {
            return Future.value(userAccount);
          });

          when(mockGetAccountsUseCase.all()).thenAnswer((_) {
            return Future.value([userAccount]);
          });

          return accountBloc;
        },
        act: (bloc) async => bloc.add(LogIn()),
        expect: [
          LoggedIn.initial(userAccount, [userAccount])
        ],
        verify: (_) async {
          verify(mockGetAccountsUseCase.all()).called(1);
        },
      );

      blocTest(
        'LogOut: to work properly',
        build: () {
          return accountBloc;
        },
        act: (bloc) async => bloc.add(LogOut('address')),
        expect: [LoggedOut()],
      );

      blocTest(
        'LogOutAll: to work properly',
        build: () {
          when(mockGetActiveAccountUseCase.single()).thenAnswer((_) {
            return Future.value(userAccount);
          });
          return accountBloc;
        },
        act: (bloc) async => bloc.add(LogOutAll()),
        expect: [LoggedOut()],
      );

      blocTest(
        'UserRefreshed: to work properly',
        build: () {
          when(mockGetAccountsUseCase.all()).thenAnswer((_) {
            return Future.value([userAccount, userAccountTwo]);
          });

          when(mockGetActiveAccountUseCase.single()).thenAnswer((_) {
            return Future.value(userAccount);
          });
          return accountBloc;
        },
        act: (bloc) async {
          bloc.add(LogIn());
          bloc.add(UserRefreshed(userAccountTwo));
        },
        expect: [
          LoggedIn(
            user: userAccount,
            refreshing: false,
            accounts: [userAccount, userAccountTwo],
          ),
          LoggedIn(
            user: userAccountTwo,
            refreshing: false,
            accounts: [userAccount, userAccountTwo],
          ),
        ],
      );

      blocTest(
        'RefreshAccount: expect no stream',
        build: () {
          return accountBloc;
        },
        act: (bloc) async {
          bloc.add(RefreshAccount());
        },
        expect: [],
      );

      blocTest(
        'RefreshAccount: to work properly',
        build: () {
          when(mockGetAccountsUseCase.all()).thenAnswer((_) {
            return Future.value([userAccount]);
          });

          when(mockGetActiveAccountUseCase.single()).thenAnswer((_) {
            return Future.value(userAccount);
          });
          return accountBloc;
        },
        act: (bloc) async {
          bloc.add(LogIn());
          bloc.add(RefreshAccount());
        },
        expect: [
          LoggedIn(
              user: userAccount, refreshing: false, accounts: [userAccount]),
          LoggedIn(
              user: userAccount, refreshing: true, accounts: [userAccount]),
          LoggedIn(
              user: userAccount, refreshing: false, accounts: [userAccount]),
        ],
      );

      blocTest(
        'SwitchAccount: to work properly',
        build: () {
          when(mockGetActiveAccountUseCase.single()).thenAnswer((_) {
            return Future.value(userAccount);
          });

          when(mockGetAccountsUseCase.all()).thenAnswer((_) {
            return Future.value([userAccount]);
          });

          return accountBloc;
        },
        act: (bloc) async {
          bloc.add(LogIn());
          bloc.add(SwitchAccount(userAccountTwo));
        },
        expect: [
          LoggedIn.initial(userAccount, [userAccount]),
        ],
        verify: (_) async {
          verify(mockGetAccountsUseCase.all()).called(1);
        },
      );
    },
  );
}
