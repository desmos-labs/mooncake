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

  HomeBloc({
    @required AccountBloc loginBloc,
    @required LogoutUseCase logoutUseCase,
  })  : assert(loginBloc != null),
        _loginBloc = loginBloc,
        assert(logoutUseCase != null),
        _logoutUseCase = logoutUseCase;

  factory HomeBloc.create(BuildContext context) {
    return HomeBloc(
      loginBloc: BlocProvider.of(context),
      logoutUseCase: Injector.get(),
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
