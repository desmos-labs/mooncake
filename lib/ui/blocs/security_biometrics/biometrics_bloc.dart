import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';

import './bloc.dart';

/// Represents the Bloc that handles the changes in the biometrics setting
/// of the user.
class BiometricsBloc extends Bloc<BiometricsEvent, BiometricsState> {
  final RecoverAccountBloc _recoverAccountBloc;
  final AccountBloc _accountBloc;

  final LoginUseCase _loginUseCase;
  final SetAuthenticationMethodUseCase _setAuthenticationMethodUseCase;

  BiometricsBloc({
    @required AccountBloc accountBloc,
    @required RecoverAccountBloc recoverAccountBloc,
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

  factory BiometricsBloc.create(BuildContext context) {
    return BiometricsBloc(
      accountBloc: BlocProvider.of(context),
      recoverAccountBloc: BlocProvider.of(context),
      loginUseCase: Injector.get(),
      setAuthenticationMethodUseCase: Injector.get(),
    );
  }

  @override
  BiometricsState get initialState => BiometricsState.initial();

  @override
  Stream<BiometricsState> mapEventToState(BiometricsEvent event) async* {
    if (event is AuthenticateWithBiometrics) {
      yield* _mapAuthenticateEventToState();
    }
  }

  Stream<BiometricsState> _mapAuthenticateEventToState() async* {
    // Set the authentication method
    yield state.copyWith(saving: true);
    await _setAuthenticationMethodUseCase.biometrics();

    // Log In
    final recoverState = _recoverAccountBloc.state;
    final mnemonic = recoverState.wordsList.join(" ");
    await _loginUseCase.login(mnemonic);
    _accountBloc.add(LogIn());
  }
}
