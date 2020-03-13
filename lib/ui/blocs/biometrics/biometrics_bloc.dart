import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';
import './bloc.dart';

/// Represents the BLoC that handles the changes in the biometrics setting
/// of the user.
class BiometricsBloc extends Bloc<BiometricsEvent, BiometricsState> {
  final RecoverAccountBloc _recoverAccountBloc;
  final AccountBloc _accountBloc;

  final LoginUseCase _loginUseCase;

  BiometricsBloc({
    @required AccountBloc accountBloc,
    @required RecoverAccountBloc recoverAccountBloc,
    @required LoginUseCase loginUseCase,
  })  : assert(recoverAccountBloc != null),
        _recoverAccountBloc = recoverAccountBloc,
        assert(accountBloc != null),
        _accountBloc = accountBloc,
        assert(loginUseCase != null),
        _loginUseCase = loginUseCase;

  factory BiometricsBloc.create(BuildContext context) {
    return BiometricsBloc(
      accountBloc: BlocProvider.of(context),
      recoverAccountBloc: BlocProvider.of(context),
      loginUseCase: Injector.get(),
    );
  }

  @override
  BiometricsState get initialState => BiometricsState();

  @override
  Stream<BiometricsState> mapEventToState(BiometricsEvent event) async* {
    if (event is AuthenticateWithBiometrics) {
      _handleAuthenticateEvent();
    }
  }

  void _handleAuthenticateEvent() async {
    final state = _recoverAccountBloc.state;
    print(state);

    final mnemonic = state.wordsList.join(" ");
    print(mnemonic);
    await _loginUseCase.login(mnemonic);
    _accountBloc.add(LogIn());
  }
}
