import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

class MockAccountBloc extends Mock implements AccountBloc {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockGetSettingUseCase extends Mock implements GetSettingUseCase {}

class MockWatchSettingUseCase extends Mock implements WatchSettingUseCase {}

class MockSaveSettingUseCase extends Mock implements SaveSettingUseCase {}

void main() {
  MockAccountBloc mockAccountBloc;
  MockLogoutUseCase mockLogoutUseCase;
  MockGetSettingUseCase mockGetSettingUseCase;
  MockSaveSettingUseCase mockSaveSettingUseCase;
  MockWatchSettingUseCase mockWatchSettingUseCase;

  setUp(() {
    mockAccountBloc = MockAccountBloc();
    mockLogoutUseCase = MockLogoutUseCase();
    mockGetSettingUseCase = MockGetSettingUseCase();
    mockSaveSettingUseCase = MockSaveSettingUseCase();
    mockWatchSettingUseCase = MockWatchSettingUseCase();
  });

  group(
    'HomeBloc',
    () {
      HomeBloc homeBloc;
      MooncakeAccount userAccount = MooncakeAccount(
        profilePicUri: "https://example.com/avatar.png",
        moniker: "john-doe",
        cosmosAccount: CosmosAccount(
          accountNumber: 153,
          address: "desmos1ew60ztvqxlf5kjjyyzxf7hummlwdadgesu3725",
          coins: [
            StdCoin(amount: "10000", denom: "udaric"),
          ],
          sequence: 45,
        ),
      );

      setUp(
        () {
          final controller = StreamController<dynamic>();
          when(mockWatchSettingUseCase.watch(key: anyNamed("key")))
              .thenAnswer((_) => controller.stream);
          homeBloc = HomeBloc(
            getSettingUseCase: mockGetSettingUseCase,
            watchSettingUseCase: mockWatchSettingUseCase,
            saveSettingUseCase: mockSaveSettingUseCase,
            loginBloc: mockAccountBloc,
            logoutUseCase: mockLogoutUseCase,
          );
        },
      );

      blocTest(
        'UpdateTab: correctly updates tab',
        build: () async {
          return homeBloc;
        },
        act: (bloc) async {
          bloc.add(UpdateTab(AppTab.likedPosts));
          bloc.add(UpdateTab(AppTab.home));
          bloc.add(UpdateTab(AppTab.account));
        },
        expect: [
          HomeState(
            showBackupPhrasePopup: false,
            activeTab: AppTab.likedPosts,
          ),
          HomeState(
            showBackupPhrasePopup: false,
            activeTab: AppTab.home,
          ),
          HomeState(
            showBackupPhrasePopup: false,
            activeTab: AppTab.account,
          ),
        ],
      );

      blocTest(
        'SignOut: no returns on logout',
        build: () async {
          return homeBloc;
        },
        act: (bloc) async {
          bloc.add(SignOut());
        },
        expect: [],
      );

      blocTest(
        'ShowBackupMnemonicPhrasePopup: to work correctly',
        build: () async {
          return homeBloc;
        },
        act: (bloc) async {
          bloc.add(ShowBackupMnemonicPhrasePopup());
        },
        expect: [
          HomeState(
            showBackupPhrasePopup: true,
            activeTab: AppTab.home,
          ),
        ],
      );

      blocTest(
        'HideBackupMnemonicPhrasePopup: to work correctly',
        build: () async {
          return homeBloc;
        },
        act: (bloc) async {
          bloc.add(ShowBackupMnemonicPhrasePopup());
          bloc.add(HideBackupMnemonicPhrasePopup());
        },
        skip: 2,
        expect: [
          HomeState(
            showBackupPhrasePopup: false,
            activeTab: AppTab.home,
          ),
        ],
      );

      blocTest(
        'TurnOffBackupMnemonicPopupPermission: no streams',
        build: () async {
          return homeBloc;
        },
        act: (bloc) async {
          bloc.add(TurnOffBackupMnemonicPopupPermission());
        },
        expect: [],
        verify: (_) async {
          verify(mockSaveSettingUseCase.save(
            key: anyNamed("key"),
            value: anyNamed("value"),
          )).called(1);
        },
      );
    },
  );
}
