import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:mooncake/entities/entities.dart';

import '../export.dart';

/// Represents the Bloc associated with the home screen.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AccountBloc _loginBloc;
  final LogoutUseCase _logoutUseCase;
  final SaveSettingUseCase _saveSettingUseCase;
  final WatchSettingUseCase _watchSettingUseCase;
  final GetSettingUseCase _getSettingUseCase;

  StreamSubscription<dynamic> _watchSettingSubscription;

  HomeBloc({
    @required AccountBloc loginBloc,
    @required LogoutUseCase logoutUseCase,
    @required SaveSettingUseCase saveSettingUseCase,
    @required WatchSettingUseCase watchSettingUseCase,
    @required GetSettingUseCase getSettingUseCase,
  })  : assert(loginBloc != null),
        _loginBloc = loginBloc,
        assert(logoutUseCase != null),
        _logoutUseCase = logoutUseCase,
        assert(saveSettingUseCase != null),
        _saveSettingUseCase = saveSettingUseCase,
        assert(watchSettingUseCase != null),
        _watchSettingUseCase = watchSettingUseCase,
        assert(getSettingUseCase != null),
        _getSettingUseCase = getSettingUseCase {
    _startSubscription();
  }

  factory HomeBloc.create(BuildContext context) {
    return HomeBloc(
      loginBloc: BlocProvider.of(context),
      logoutUseCase: Injector.get(),
      saveSettingUseCase: Injector.get(),
      watchSettingUseCase: Injector.get(),
      getSettingUseCase: Injector.get(),
    );
  }

  @override
  HomeState get initialState {
    return HomeState.initial();
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is UpdateTab) {
      yield state.copyWith(activeTab: event.tab);
    } else if (event is SignOut) {
      _mapSignOutToState();
      _loginBloc.add(LogOut());
    } else if (event is ShowBackupMnemonicPhrasePopup) {
      yield state.copyWith(showBackupPhrasePopup: true);
    } else if (event is HideBackupMnemonicPhrasePopup) {
      yield state.copyWith(showBackupPhrasePopup: false);
    } else if (event is TurnOffBackupMnemonicPopupPermission) {
      _mapTurnOffBackupMnemonicPopupPermissionToState();
    }
  }

  void _startSubscription() async {
    if (_watchSettingSubscription == null) {
      _watchSettingUseCase
          .watch(key: SettingKeys.TX_AMOUNT)
          .listen((value) async {
        final checkTxAmount = (value == 5) || (value != 0 && value % 10 == 0);
        final checkPopupPermission = await _getSettingUseCase.get(
                key: SettingKeys.BACKUP_POPUP_PERMISSION) ??
            true;
        if (checkTxAmount && checkPopupPermission == true) {
          this.add(ShowBackupMnemonicPhrasePopup());
        } else {
          this.add(HideBackupMnemonicPhrasePopup());
        }
      });
    }

    // wingman testing
    await _saveSettingUseCase.save(key: SettingKeys.TX_AMOUNT, value: 5);
  }

  /// handles SignOut [event]
  void _mapSignOutToState() async {
    this._stopSubscription();
    await _logoutUseCase.logout();
  }

  /// Stops all valid subscriptons
  void _stopSubscription() {
    _watchSettingSubscription?.cancel();
    _watchSettingSubscription = null;
  }

  /// handles TurnOffBackupMnemonicPopupPermission [event]
  _mapTurnOffBackupMnemonicPopupPermissionToState() async {
    await _saveSettingUseCase.save(
        key: SettingKeys.BACKUP_POPUP_PERMISSION, value: false);
  }
}
