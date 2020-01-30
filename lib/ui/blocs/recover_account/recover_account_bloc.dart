import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Bloc that allows to properly handle the recovering account events
/// and emits the correct states.
class RecoverAccountBloc
    extends Bloc<RecoverAccountEvent, RecoverAccountState> {
  final LoginUseCase _loginUseCase;
  final GetAddressUseCase _getAddressUseCase;

  MnemonicInputBloc _mnemonicInputBloc;
  LoginBloc _loginBloc;

  StreamSubscription _mnemonicBlocSubscription;

  RecoverAccountBloc({
    @required MnemonicInputBloc mnemonicInputBloc,
    @required LoginBloc loginBloc,
    @required LoginUseCase loginUseCase,
    @required GetAddressUseCase getAddressUseCase,
  })  : assert(mnemonicInputBloc != null),
        _mnemonicInputBloc = mnemonicInputBloc,
        assert(loginBloc != null),
        _loginBloc = loginBloc,
        assert(loginUseCase != null),
        this._loginUseCase = loginUseCase,
        assert(getAddressUseCase != null),
        this._getAddressUseCase = getAddressUseCase {
    // Observe the mnemonic changes to react tot them
    _mnemonicBlocSubscription = mnemonicInputBloc.listen((mnemonicState) {
      add(MnemonicInputChanged(mnemonicState));
    });
  }

  @override
  RecoverAccountState get initialState =>
      TypingMnemonic(_mnemonicInputBloc.state);

  @override
  Stream<RecoverAccountState> mapEventToState(
    RecoverAccountEvent event,
  ) async* {
    if (event is MnemonicInputChanged) {
      yield TypingMnemonic(event.mnemonicInputState);
    } else if (event is RecoverAccount) {
      yield* _mapRecoverAccountToState(event);
    } else if (event is AccountRecoveredSuccessfully) {
      yield* _mapAccountRecoveredSuccessfullyEventToState(event);
    }
  }

  Stream<RecoverAccountState> _mapRecoverAccountToState(
    RecoverAccount event,
  ) async* {
    yield RecoveringAccount();

    final state = _mnemonicInputBloc.state;
    if (state.isValid) {
      _loginUseCase
          .login(state.mnemonic)
          .then((_) => _getAddressUseCase.get())
          .then((address) => add(AccountRecoveredSuccessfully(address)));
    }
  }

  Stream<RecoverAccountState> _mapAccountRecoveredSuccessfullyEventToState(
    AccountRecoveredSuccessfully event,
  ) async* {
    final state = _mnemonicInputBloc.state;
    yield RecoveredAccount(state.mnemonic);
    _loginBloc.add(LogIn(state.mnemonic));
  }

  @override
  Future<void> close() {
    _mnemonicBlocSubscription.cancel();
    return super.close();
  }
}
