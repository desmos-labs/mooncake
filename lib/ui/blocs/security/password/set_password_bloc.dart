import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:mooncake/ui/ui.dart';
import 'bloc.dart';

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
      yield state.copyWith(inputPassword: event.newPassword);
    } else if (event is TriggerPasswordVisibility) {
      yield state.copyWith(showPassword: !state.showPassword);
    } else if (event is SavePassword) {
      yield* _mapSavePasswordEventToState();
    }
  }

  Stream<SetPasswordState> _mapSavePasswordEventToState() async* {
    // Store authentication method
    await _setAuthenticationMethodUseCase.password(state.inputPassword);
    yield state.copyWith(savingPassword: true);

    // Log In
    final mnemonic = getMnemonic(_recoverAccountBloc.state, _accountBloc.state);
    await _loginUseCase.login(mnemonic);
    _accountBloc.add(LogIn());
  }
}
