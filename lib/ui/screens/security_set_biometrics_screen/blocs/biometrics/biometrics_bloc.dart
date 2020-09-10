import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'export.dart';

/// Represents the Bloc that handles the changes in the biometrics setting
/// of the user.
class BiometricsBloc extends Bloc<BiometricsEvent, BiometricsState> {
  final RecoverAccountBloc _recoverAccountBloc;
  final AccountBloc _accountBloc;

  final LoginUseCase _loginUseCase;
  final GetAvailableBiometricsUseCase _getAvailableBiometricsUseCase;
  final SetAuthenticationMethodUseCase _setAuthenticationMethodUseCase;
  final SaveWalletUseCase _saveWalletUseCase;

  BiometricsBloc({
    @required AccountBloc accountBloc,
    @required RecoverAccountBloc recoverAccountBloc,
    @required LoginUseCase loginUseCase,
    @required GetAvailableBiometricsUseCase getAvailableBiometricsUseCase,
    @required SetAuthenticationMethodUseCase setAuthenticationMethodUseCase,
    @required SaveWalletUseCase saveWalletUseCase,
  })  : assert(recoverAccountBloc != null),
        _recoverAccountBloc = recoverAccountBloc,
        assert(accountBloc != null),
        _accountBloc = accountBloc,
        assert(loginUseCase != null),
        _loginUseCase = loginUseCase,
        assert(getAvailableBiometricsUseCase != null),
        _getAvailableBiometricsUseCase = getAvailableBiometricsUseCase,
        assert(saveWalletUseCase != null),
        _saveWalletUseCase = saveWalletUseCase,
        assert(setAuthenticationMethodUseCase != null),
        _setAuthenticationMethodUseCase = setAuthenticationMethodUseCase,
        super(BiometricsState.initial());

  factory BiometricsBloc.create(BuildContext context) {
    return BiometricsBloc(
      accountBloc: BlocProvider.of(context),
      recoverAccountBloc: BlocProvider.of(context),
      loginUseCase: Injector.get(),
      getAvailableBiometricsUseCase: Injector.get(),
      setAuthenticationMethodUseCase: Injector.get(),
      saveWalletUseCase: Injector.get(),
    );
  }

  @override
  Stream<BiometricsState> mapEventToState(BiometricsEvent event) async* {
    if (event is AuthenticateWithBiometrics) {
      yield* _mapAuthenticateEventToState();
    } else if (event is CheckAuthenticationType) {
      yield* _mapCheckAuthenticationTypeEventToState();
    }
  }

  Stream<BiometricsState> _mapAuthenticateEventToState() async* {
    yield state.copyWith(saving: true);
    final isLoggedIn = _accountBloc.state is LoggedIn;
    final mnemonic = getMnemonic(_recoverAccountBloc.state, _accountBloc.state);

    // Save wallet and get unique address
    final wallet = await _saveWalletUseCase.saveWallet(mnemonic);

    // Set the authentication method
    await _setAuthenticationMethodUseCase.biometrics(wallet.bech32Address);

    // Log In
    await _loginUseCase.login(wallet, setActive: !isLoggedIn);

    _recoverAccountBloc.add(ResetRecoverAccountState());
    _accountBloc.add(LogIn());
  }

  Stream<BiometricsState> _mapCheckAuthenticationTypeEventToState() async* {
    final types = await _getAvailableBiometricsUseCase.get();
    if (types.contains(BiometricType.face)) {
      yield state.copyWith(availableBiometric: BiometricType.face);
    }
  }
}
