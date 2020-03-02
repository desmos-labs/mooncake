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
class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final LoginUseCase _loginUseCase;
  final GetUserUseCase _getUserUseCase;
  final FirebaseAnalytics _analytics;

  final NavigatorBloc _navigatorBloc;

  StreamSubscription _accountSubscription;

  AccountBloc({
    @required LoginUseCase loginUseCase,
    @required GetUserUseCase getUserUseCase,
    @required NavigatorBloc navigatorBloc,
    @required FirebaseAnalytics analytics,
  })  : assert(loginUseCase != null),
        _loginUseCase = loginUseCase,
        assert(getUserUseCase != null),
        _getUserUseCase = getUserUseCase,
        assert(navigatorBloc != null),
        _navigatorBloc = navigatorBloc,
        assert(analytics != null),
        _analytics = analytics {
    // Listen for account changes so that we know when to refresh
    _accountSubscription = _getUserUseCase.stream().listen((account) {
      add(Refresh(account));
    });
  }

  factory AccountBloc.create(BuildContext context) {
    return AccountBloc(
      loginUseCase: Injector.get(),
      getUserUseCase: Injector.get(),
      navigatorBloc: BlocProvider.of(context),
      analytics: Injector.get(),
    );
  }

  @override
  AccountState get initialState => Loading();

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
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

  Stream<AccountState> _mapCheckStatusEventToState() async* {
    final account = await _getUserUseCase.single();
    if (account != null) {
      yield LoggedIn(account);
    } else {
      yield LoggedOut();
    }
  }

  Stream<AccountState> _mapLogInEventToState(LogIn event) async* {
    await _loginUseCase.login(event.mnemonic);
    final account = await _getUserUseCase.single();
    yield LoggedIn(account);
    _navigatorBloc.add(NavigateToHome());
  }

  Stream<AccountState> _mapLogOutEventToState() async* {
    yield LoggedOut();
  }

  @override
  Future<Function> close() {
    _accountSubscription.cancel();
  }
}
