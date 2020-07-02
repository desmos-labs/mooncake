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
  final AccountBloc _loginBloc;
  final LogoutUseCase _logoutUseCase;
  final SetMnemonicBackupPopupUseCase _setMnemonicBackupPopupUseCase;
  final SaveSettingUseCase _saveSettingUseCase;
  final GetSettingUseCase _getSettingUseCase;
  HomeBloc({
    @required AccountBloc loginBloc,
    @required LogoutUseCase logoutUseCase,
    @required GetSettingUseCase getSettingUseCase,
    @required SetMnemonicBackupPopupUseCase setMnemonicBackupPopupUseCase,
    @required SaveSettingUseCase saveSettingUseCase,
  })  : assert(loginBloc != null),
        _loginBloc = loginBloc,
        assert(setMnemonicBackupPopupUseCase != null),
        _setMnemonicBackupPopupUseCase = setMnemonicBackupPopupUseCase,
        assert(logoutUseCase != null),
        _logoutUseCase = logoutUseCase,
        assert(saveSettingUseCase != null),
        _saveSettingUseCase = saveSettingUseCase,
        assert(getSettingUseCase != null),
        _getSettingUseCase = getSettingUseCase {
    final shouldPopup = setMnemonicBackupPopupUseCase.setMnemonicBackupPopup();
    print('=====should pop up======');
    print(shouldPopup);
    print('=====should pop up======');
  }

  factory HomeBloc.create(BuildContext context) {
    return HomeBloc(
      loginBloc: BlocProvider.of(context),
      logoutUseCase: Injector.get(),
      saveSettingUseCase: Injector.get(),
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
      await _logoutUseCase.logout();
      _loginBloc.add(LogOut());
    }
  }
}
