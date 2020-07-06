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
class HomeBloc extends Bloc<HomeEvent, AppTab> {
  final AccountBloc _loginBloc;
  final LogoutUseCase _logoutUseCase;
  final GetSettingUseCase _getSettingUseCase;

  HomeBloc({
    @required AccountBloc loginBloc,
    @required LogoutUseCase logoutUseCase,
    @required GetSettingUseCase getSettingUseCase,
  })  : assert(loginBloc != null),
        _loginBloc = loginBloc,
        assert(logoutUseCase != null),
        _logoutUseCase = logoutUseCase,
        assert(getSettingUseCase != null),
        _getSettingUseCase = getSettingUseCase {
    // i want to call the first check here
    // BlocProvider.of<MnemonicBloc>(context)
    //           .add(ValidateBackupMnemonicPopupState());
  }

  factory HomeBloc.create(BuildContext context) {
    return HomeBloc(
      loginBloc: BlocProvider.of(context),
      logoutUseCase: Injector.get(),
    );
  }

  @override
  AppTab get initialState => AppTab.home;

  @override
  Stream<AppTab> mapEventToState(HomeEvent event) async* {
    if (event is UpdateTab) {
      yield event.tab;
    } else if (event is SignOut) {
      await _logoutUseCase.logout();
      _loginBloc.add(LogOut());
    }
  }
}
