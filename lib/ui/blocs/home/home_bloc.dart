import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:meta/meta.dart';

import '../export.dart';

class HomeBloc extends Bloc<HomeEvent, AppTab> {
  final LogoutUseCase _logoutUseCase;

  final LoginBloc _loginBloc;

  HomeBloc({
    @required LoginBloc loginBloc,
    @required LogoutUseCase logoutUseCase,
  })  : assert(loginBloc != null),
        _loginBloc = loginBloc,
        assert(logoutUseCase != null),
        _logoutUseCase = logoutUseCase;

  @override
  AppTab get initialState => AppTab.posts;

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
