import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'export.dart';

/// Represents the Bloc that is used inside the screen allowing the user
/// to set a custom password to protect his account.
class SetPasswordBloc extends Bloc<SetPasswordEvent, SetPasswordState> {
  final RecoverAccountBloc _recoverAccountBloc;
  final AccountBloc _accountBloc;

  final LoginUseCase _loginUseCase;
  final SetAuthenticationMethodUseCase _setAuthenticationMethodUseCase;
  final SaveWalletUseCase _saveWalletUseCase;
  SetPasswordBloc({
    @required RecoverAccountBloc recoverAccountBloc,
    @required AccountBloc accountBloc,
    @required LoginUseCase loginUseCase,
    @required SetAuthenticationMethodUseCase setAuthenticationMethodUseCase,
    @required SaveWalletUseCase saveWalletUseCase,
  })  : assert(recoverAccountBloc != null),
        _recoverAccountBloc = recoverAccountBloc,
        assert(accountBloc != null),
        _accountBloc = accountBloc,
        assert(loginUseCase != null),
        _loginUseCase = loginUseCase,
        assert(saveWalletUseCase != null),
        _saveWalletUseCase = saveWalletUseCase,
        assert(setAuthenticationMethodUseCase != null),
        _setAuthenticationMethodUseCase = setAuthenticationMethodUseCase,
        super(SetPasswordState.initial());

  factory SetPasswordBloc.create(BuildContext context) {
    return SetPasswordBloc(
      recoverAccountBloc: BlocProvider.of(context),
      accountBloc: BlocProvider.of(context),
      loginUseCase: Injector.get(),
      setAuthenticationMethodUseCase: Injector.get(),
      saveWalletUseCase: Injector.get(),
    );
  }

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
    yield state.copyWith(savingPassword: true);
    final isLoggedIn = _accountBloc.state is LoggedIn;
    final mnemonic = getMnemonic(_recoverAccountBloc.state, _accountBloc.state);
    // Save wallet and get unique address
    final wallet = await _saveWalletUseCase.saveWallet(mnemonic);

    // Store authentication method
    await _setAuthenticationMethodUseCase.password(
        wallet.bech32Address, state.inputPassword);

    // Log In
    await _loginUseCase.login(wallet, setActive: !isLoggedIn);

    // reset state
    _recoverAccountBloc.add(ResetRecoverAccountState());
    _accountBloc.add(LogIn());
  }
}
