import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:meta/meta.dart';

/// Handles the login events and emits the proper state instances.
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final CheckLoginUseCase _checkLoginUseCase;

  final NavigatorBloc _navigatorBloc;
  StreamSubscription _recoverAccountSubscription;

  LoginBloc(
      {@required NavigatorBloc navigatorBloc,
      @required CheckLoginUseCase checkLoginUseCase})
      : assert(navigatorBloc != null),
        _navigatorBloc = navigatorBloc,
        assert(checkLoginUseCase != null),
        _checkLoginUseCase = checkLoginUseCase;

  @override
  LoginState get initialState => Loading();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is CheckStatus) {
      yield* _mapCheckStatusEventToState();
    } else if (event is LogIn) {
      yield* _mapLogInEventToState(event);
    } else if (event is LogOut) {
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

  @override
  Future<void> close() {
    _recoverAccountSubscription.cancel();
    return super.close();
  }
}
