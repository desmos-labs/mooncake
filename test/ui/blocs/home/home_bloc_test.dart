import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

class MockAccountBloc extends Mock implements AccountBloc {}

class MockGetSettingUseCase extends Mock implements GetSettingUseCase {}

class MockWatchSettingUseCase extends Mock implements WatchSettingUseCase {}

class MockSaveSettingUseCase extends Mock implements SaveSettingUseCase {}

void main() {
  MockAccountBloc mockAccountBloc;
  MockGetSettingUseCase mockGetSettingUseCase;
  MockSaveSettingUseCase mockSaveSettingUseCase;
  MockWatchSettingUseCase mockWatchSettingUseCase;

  setUp(() {
    mockAccountBloc = MockAccountBloc();
    mockGetSettingUseCase = MockGetSettingUseCase();
    mockSaveSettingUseCase = MockSaveSettingUseCase();
    mockWatchSettingUseCase = MockWatchSettingUseCase();
  });

  group(
    'HomeBloc',
    () {
      HomeBloc homeBloc;

      setUp(
        () {
          final controller = StreamController<dynamic>();
          when(mockWatchSettingUseCase.watch(key: anyNamed('key')))
              .thenAnswer((_) => controller.stream);
          homeBloc = HomeBloc(
            getSettingUseCase: mockGetSettingUseCase,
            watchSettingUseCase: mockWatchSettingUseCase,
            saveSettingUseCase: mockSaveSettingUseCase,
            loginBloc: mockAccountBloc,
          );
        },
      );

      blocTest(
        'UpdateTab: correctly updates tab',
        build: () {
          return homeBloc;
        },
        act: (bloc) async {
          bloc.add(UpdateTab(AppTab.likedPosts));
          bloc.add(UpdateTab(AppTab.home));
          bloc.add(UpdateTab(AppTab.account));
          bloc.add(UpdateTab(AppTab.account));
        },
        expect: [
          HomeState(
            showBackupPhrasePopup: false,
            activeTab: AppTab.likedPosts,
            scrollToTop: false,
          ),
          HomeState(
            showBackupPhrasePopup: false,
            activeTab: AppTab.home,
            scrollToTop: false,
          ),
          HomeState(
            showBackupPhrasePopup: false,
            activeTab: AppTab.account,
            scrollToTop: false,
          ),
          HomeState(
            showBackupPhrasePopup: false,
            activeTab: AppTab.account,
            scrollToTop: true,
          ),
        ],
      );

      blocTest(
        'SignOut: no returns on logout',
        build: () {
          return homeBloc;
        },
        act: (bloc) async {
          bloc.add(SignOut('address'));
        },
        expect: [],
      );

      blocTest(
        'ShowBackupMnemonicPhrasePopup: to work correctly',
        build: () {
          return homeBloc;
        },
        act: (bloc) async {
          bloc.add(ShowBackupMnemonicPhrasePopup());
        },
        expect: [
          HomeState(
            showBackupPhrasePopup: true,
            activeTab: AppTab.home,
            scrollToTop: false,
          ),
        ],
      );

      blocTest(
        'HideBackupMnemonicPhrasePopup: to work correctly',
        build: () {
          return homeBloc;
        },
        act: (bloc) async {
          bloc.add(ShowBackupMnemonicPhrasePopup());
          bloc.add(HideBackupMnemonicPhrasePopup());
        },
        skip: 1,
        expect: [
          HomeState(
            showBackupPhrasePopup: false,
            activeTab: AppTab.home,
            scrollToTop: false,
          ),
        ],
      );

      blocTest(
        'TurnOffBackupMnemonicPopupPermission: no streams',
        build: () {
          return homeBloc;
        },
        act: (bloc) async {
          bloc.add(TurnOffBackupMnemonicPopupPermission());
        },
        skip: 1,
        expect: [],
        verify: (_) async {
          verify(mockSaveSettingUseCase.save(
            key: anyNamed('key'),
            value: anyNamed('value'),
          )).called(1);
        },
      );

      blocTest(
        'SetScrollToTop: correctly updates state',
        build: () {
          return homeBloc;
        },
        act: (bloc) async {
          bloc.add(SetScrollToTop(true));
          bloc.add(SetScrollToTop(false));
        },
        expect: [
          HomeState(
            showBackupPhrasePopup: false,
            activeTab: AppTab.home,
            scrollToTop: true,
          ),
          HomeState(
            showBackupPhrasePopup: false,
            activeTab: AppTab.home,
            scrollToTop: false,
          ),
        ],
      );
    },
  );
}
