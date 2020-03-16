import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:password_strength/password_strength.dart';
import 'package:mooncake/ui/ui.dart';
import './bloc.dart';

/// Represents the Bloc that is used inside the screen allowing the user
/// to set a custom password to protect his account.
class SetPasswordBloc extends Bloc<SetPasswordEvent, SetPasswordState> {
  final RecoverAccountBloc _recoverAccountBloc;
  final AccountBloc _accountBloc;

  final LoginUseCase _loginUseCase;
  final SetAuthenticationMethodUseCase _setAuthenticationMethodUseCase;

  SetPasswordBloc({
    @required RecoverAccountBloc recoverAccountBloc,
    @required AccountBloc accountBloc,
    @required LoginUseCase loginUseCase,
    @required SetAuthenticationMethodUseCase setAuthenticationMethodUseCase,
  })  : assert(recoverAccountBloc != null),
        _recoverAccountBloc = recoverAccountBloc,
        assert(accountBloc != null),
        _accountBloc = accountBloc,
        assert(loginUseCase != null),
        _loginUseCase = loginUseCase,
        assert(setAuthenticationMethodUseCase != null),
        _setAuthenticationMethodUseCase = setAuthenticationMethodUseCase;

  factory SetPasswordBloc.create(BuildContext context) {
    return SetPasswordBloc(
      recoverAccountBloc: BlocProvider.of(context),
      accountBloc: BlocProvider.of(context),
      loginUseCase: Injector.get(),
      setAuthenticationMethodUseCase: Injector.get(),
    );
  }

  @override
  SetPasswordState get initialState => SetPasswordState.initial();

  @override
  Stream<SetPasswordState> mapEventToState(SetPasswordEvent event) async* {
    if (event is PasswordChanged) {
      yield* _mapPasswordChangedEventToState(event);
    } else if (event is TriggerPasswordVisibility) {
      yield* _mapTriggerPasswordVisibilityEventToState();
    } else if (event is SavePassword) {
      yield* _mapSavePasswordEventToState();
    }
  }

  Stream<SetPasswordState> _mapPasswordChangedEventToState(
    PasswordChanged event,
  ) async* {
    final strength = estimatePasswordStrength(event.newPassword);
    PasswordSecurity security = PasswordSecurity.UNKNOWN;
    if (strength < 0.50) {
      security = PasswordSecurity.LOW;
    } else if (strength < 0.75) {
      security = PasswordSecurity.MEDIUM;
    } else {
      security = PasswordSecurity.HIGH;
    }

    yield state.copyWith(
      inputPassword: event.newPassword,
      passwordSecurity: security,
    );
  }

  Stream<SetPasswordState> _mapTriggerPasswordVisibilityEventToState() async* {
    yield state.copyWith(showPassword: !state.showPassword);
  }

  Stream<SetPasswordState> _mapSavePasswordEventToState() async* {
    // Store authentication method
    await _setAuthenticationMethodUseCase.password(state.inputPassword);
    yield state.copyWith(savingPassword: true);

    // Log In
    final recoverState = _recoverAccountBloc.state;
    final mnemonic = recoverState.wordsList.join(" ");
    await _loginUseCase.login(mnemonic);
    _accountBloc.add(LogIn());
  }
}
