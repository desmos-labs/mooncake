import 'dart:async';

import 'package:bloc/bloc.dart';

import './bloc.dart';

/// Handles the events that are emitted from the text input that allows
/// a user to input a mnemonic phrase.
class MnemonicInputBloc extends Bloc<MnemonicInputEvent, MnemonicInputState> {
  @override
  MnemonicInputState get initialState => MnemonicInputState.empty();

  @override
  Stream<MnemonicInputState> mapEventToState(
    MnemonicInputEvent event,
  ) async* {
    if (event is MnemonicChanged) {
      yield state.update(mnemonic: event.mnemonic);
    } else if (event is Reset) {
      yield MnemonicInputState.empty();
    }
  }
}
