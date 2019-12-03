import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:desmosdemo/ui/ui.dart';
import 'package:meta/meta.dart';

/// Bloc that allows to properly handle the recovering account events
/// and emits the correct states.
class RecoverAccountBloc
    extends Bloc<RecoverAccountEvent, RecoverAccountState> {
  MnemonicInputBloc _mnemonicInputBloc;
  LoginBloc _loginBloc;

  StreamSubscription _mnemonicBlocSubscription;

  RecoverAccountBloc({
    @required MnemonicInputBloc mnemonicInputBloc,
    @required LoginBloc loginBloc,
  })  : assert(mnemonicInputBloc != null),
        _mnemonicInputBloc = mnemonicInputBloc,
        assert(loginBloc != null),
        _loginBloc = loginBloc {
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
    }
  }

  Stream<RecoverAccountState> _mapRecoverAccountToState(
    RecoverAccount event,
  ) async* {
    yield RecoveringAccount();
    if (_mnemonicInputBloc.state.isValid) {
      yield RecoveredAccount(_mnemonicInputBloc.state.mnemonic);
      _loginBloc.add(LogIn(_mnemonicInputBloc.state.mnemonic));
    }
  }

  @override
  Future<void> close() {
    _mnemonicBlocSubscription.cancel();
    return super.close();
  }
}
