import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Handles the login events and emits the proper state instances.
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final NavigatorBloc _navigatorBloc;
  final CheckLoginUseCase _checkLoginUseCase;
  final FirebaseAnalytics _analytics;

  LoginBloc({
    @required NavigatorBloc navigatorBloc,
    @required CheckLoginUseCase checkLoginUseCase,
    @required FirebaseAnalytics analytics,
  })  : assert(navigatorBloc != null),
        _navigatorBloc = navigatorBloc,
        assert(checkLoginUseCase != null),
        _checkLoginUseCase = checkLoginUseCase,
        assert(analytics != null),
        _analytics = analytics;

  factory LoginBloc.create(BuildContext context) {
    return LoginBloc(
      navigatorBloc: BlocProvider.of(context),
      checkLoginUseCase: Injector.get(),
      analytics: Injector.get(),
    );
  }

  @override
  LoginState get initialState => Loading();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is CheckStatus) {
      yield* _mapCheckStatusEventToState();
    } else if (event is LogIn) {
      _analytics.logLogin();
      yield* _mapLogInEventToState(event);
    } else if (event is LogOut) {
      _analytics.logEvent(name: Constants.EVENT_LOGOUT);
      yield* _mapLogOutEventToState();
    }
  }

  Stream<LoginState> _mapCheckStatusEventToState() async* {
    if (await _checkLoginUseCase.isLoggedIn()) {
      yield LoggedIn();
    } else {
      yield LoggedOut();
    }
  }

  Stream<LoginState> _mapLogInEventToState(LogIn event) async* {
    yield LoggedIn();
    _navigatorBloc.add(NavigateToHome());
  }

  Stream<LoginState> _mapLogOutEventToState() async* {
    yield LoggedOut();
    _navigatorBloc.add(NavigateToHome());
  }
}
