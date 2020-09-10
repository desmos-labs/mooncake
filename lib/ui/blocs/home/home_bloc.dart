import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

import '../export.dart';

/// Represents the Bloc associated with the home screen.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AccountBloc _loginBloc;
  final SaveSettingUseCase _saveSettingUseCase;
  final WatchSettingUseCase _watchSettingUseCase;
  final GetSettingUseCase _getSettingUseCase;

  StreamSubscription<dynamic> _watchSettingSubscription;

  HomeBloc({
    @required AccountBloc loginBloc,
    @required SaveSettingUseCase saveSettingUseCase,
    @required WatchSettingUseCase watchSettingUseCase,
    @required GetSettingUseCase getSettingUseCase,
  })  : assert(loginBloc != null),
        _loginBloc = loginBloc,
        assert(saveSettingUseCase != null),
        _saveSettingUseCase = saveSettingUseCase,
        assert(watchSettingUseCase != null),
        _watchSettingUseCase = watchSettingUseCase,
        assert(getSettingUseCase != null),
        _getSettingUseCase = getSettingUseCase,
        super(HomeState.initial()) {
    _startSubscription();
  }

  factory HomeBloc.create(BuildContext context) {
    return HomeBloc(
      loginBloc: BlocProvider.of(context),
      saveSettingUseCase: Injector.get(),
      watchSettingUseCase: Injector.get(),
      getSettingUseCase: Injector.get(),
    );
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is UpdateTab) {
      yield* _mapUpdateTabToState(event);
    } else if (event is SignOut) {
      _mapSignOutToState(event);
    } else if (event is ShowBackupMnemonicPhrasePopup) {
      yield* _mapShowBackupMnemonicPhrasePopupToState();
    } else if (event is HideBackupMnemonicPhrasePopup) {
      yield* _mapHideBackupMnemonicPhrasePopupToState();
    } else if (event is TurnOffBackupMnemonicPopupPermission) {
      yield* _mapTurnOffBackupMnemonicPopupPermissionToState();
    } else if (event is SetScrollToTop) {
      yield state.copyWith(
        scrollToTop: event.scroll,
      );
    }
  }

  void _startSubscription() async {
    _watchSettingSubscription ??= _watchSettingUseCase
        .watch(key: SettingKeys.TX_AMOUNT)
        .listen((value) async {
      final checkTxAmount = (value == 5) || (value != 0 && value % 10 == 0);
      final checkPopupPermission = await _getSettingUseCase.get(
        key: SettingKeys.BACKUP_POPUP_PERMISSION,
      );

      if (checkTxAmount && checkPopupPermission != false) {
        add(ShowBackupMnemonicPhrasePopup());
      } else {
        add(HideBackupMnemonicPhrasePopup());
      }
    });
  }

  /// handles SignOut [event]
  void _mapSignOutToState(SignOut event) {
    _stopSubscription();
    _loginBloc.add(LogOut(event.address));
  }

  /// Stops all valid subscriptions
  void _stopSubscription() {
    _watchSettingSubscription?.cancel();
    _watchSettingSubscription = null;
  }

  /// Tells the state to show mnemonic phrase backup popup
  Stream<HomeState> _mapShowBackupMnemonicPhrasePopupToState() async* {
    yield state.copyWith(showBackupPhrasePopup: true);
  }

  /// Tells the state to hide mnemonic phrase backup popup
  Stream<HomeState> _mapHideBackupMnemonicPhrasePopupToState() async* {
    yield state.copyWith(showBackupPhrasePopup: false);
  }

  /// handles TurnOffBackupMnemonicPopupPermission [event]
  Stream<HomeState> _mapTurnOffBackupMnemonicPopupPermissionToState() async* {
    await _saveSettingUseCase.save(
      key: SettingKeys.BACKUP_POPUP_PERMISSION,
      value: false,
    );
    yield state.copyWith(showBackupPhrasePopup: false);
  }

  /// tells screens whether to scroll to top
  Stream<HomeState> _mapUpdateTabToState(UpdateTab event) async* {
    yield state.copyWith(
      activeTab: event.tab,
      scrollToTop: state.activeTab == event.tab,
    );
  }
}
