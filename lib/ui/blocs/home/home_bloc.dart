import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/usecases/usecases.dart';

import '../export.dart';

/// Represents the Bloc associated with the home screen.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  static const INIT_CHECK = 'INIT_CHECK';
  static const LOCAL_SAVE_TX_AMOUNT = 'txAmount';
  static const BACKUP_PERMISSION = 'backupPopupPermission';
  final AccountBloc _loginBloc;
  final LogoutUseCase _logoutUseCase;
  final SetMnemonicBackupPopupUseCase _setMnemonicBackupPopupUseCase;
  final WatchSettingUseCase _watchSettingUseCase;
  final SaveSettingUseCase _saveSettingUseCase;
  StreamSubscription<dynamic> _watchSettingSubscription;

  HomeBloc({
    @required AccountBloc loginBloc,
    @required LogoutUseCase logoutUseCase,
    @required SetMnemonicBackupPopupUseCase setMnemonicBackupPopupUseCase,
    @required WatchSettingUseCase watchSettingUseCase,
    @required SaveSettingUseCase saveSettingUseCase,
  })  : assert(loginBloc != null),
        _loginBloc = loginBloc,
        assert(setMnemonicBackupPopupUseCase != null),
        _setMnemonicBackupPopupUseCase = setMnemonicBackupPopupUseCase,
        assert(logoutUseCase != null),
        _logoutUseCase = logoutUseCase,
        assert(watchSettingUseCase != null),
        _watchSettingUseCase = watchSettingUseCase,
        assert(saveSettingUseCase != null),
        _saveSettingUseCase = saveSettingUseCase {
    _startSubscription();
  }

  factory HomeBloc.create(BuildContext context) {
    return HomeBloc(
      loginBloc: BlocProvider.of(context),
      logoutUseCase: Injector.get(),
      setMnemonicBackupPopupUseCase: Injector.get(),
      watchSettingUseCase: Injector.get(),
      saveSettingUseCase: Injector.get(),
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
      _stopSubscription();
      await _logoutUseCase.logout();
      _loginBloc.add(LogOut());
    } else if (event is ShowBackupMnemonicPhrasePopup) {
      yield state.copyWith(showBackupPhrasePopup: true);
    } else if (event is HideBackupMnemonicPhrasePopup) {
      yield state.copyWith(showBackupPhrasePopup: false);
    } else if (event is TurnOffBackupMnemonicPopupPermission) {
      _mapTurnOffBackupMnemonicPopupPermissionToState();
    }
  }

  /// starts all subscriptions
  void _startSubscription() async {
    // wingman remove later
    // await _saveSettingUseCase.save(key: 'backupPopupPermission', value: true);
    // await _saveSettingUseCase.save(key: 'txAmount', value: 5);
    if (_watchSettingSubscription == null) {
      _watchSettingSubscription =
          _watchSettingUseCase.watch.stream.listen((event) async {
        print('=====event======');
        print(event);
        print('=====event======');
        if ([INIT_CHECK, LOCAL_SAVE_TX_AMOUNT, BACKUP_PERMISSION]
            .contains(event)) {
          bool shouldShowPopup = await _setMnemonicBackupPopupUseCase.check();
          if (shouldShowPopup) {
            this.add(ShowBackupMnemonicPhrasePopup());
          } else {
            this.add(HideBackupMnemonicPhrasePopup());
          }
        }
      });
      _watchSettingUseCase.watch.add(INIT_CHECK);
    }
  }

  /// Stops all valid subscriptons
  void _stopSubscription() {
    _watchSettingSubscription?.cancel();
    _watchSettingSubscription = null;
  }

  _mapTurnOffBackupMnemonicPopupPermissionToState() async {
    await _saveSettingUseCase.save(key: 'backupPopupPermission', value: false);
  }
}
