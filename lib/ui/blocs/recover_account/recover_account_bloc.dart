import 'dart:async';

import 'package:bip39/bip39.dart' as bip39;
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

/// Bloc that allows to properly handle the recovering account events
/// and emits the correct states.
class RecoverAccountBloc
    extends Bloc<RecoverAccountEvent, RecoverAccountState> {
  RecoverAccountBloc();

  factory RecoverAccountBloc.create() {
    return RecoverAccountBloc();
  }

  @override
  RecoverAccountState get initialState => RecoverAccountState.initial();

  @override
  Stream<RecoverAccountState> mapEventToState(
    RecoverAccountEvent event,
  ) async* {
    if (event is ResetRecoverAccountState) {
      yield RecoverAccountState.initial();
    } else if (event is TypeWord) {
      yield* _mapTypeWordEventToState(event);
    } else if (event is WordSelected) {
      yield* _mapWordSelectedEventToState(event);
    } else if (event is ChangeFocus) {
      yield* _mapChangeFocusEventToState(event);
    }
  }

  Stream<RecoverAccountState> _mapTypeWordEventToState(TypeWord event) async* {
    final wordsList = List<String>()..addAll(state.wordsList);
    wordsList[event.index] = event.word;
    yield state.copyWith(
      wordsList: wordsList,
      currentWordIndex: event.index,
      isMnemonicValid: bip39.validateMnemonic(wordsList.join(" ")),
    );
  }

  Stream<RecoverAccountState> _mapWordSelectedEventToState(
    WordSelected event,
  ) async* {
    // Update the words list
    final wordsList = List<String>()..addAll(state.wordsList);
    wordsList[state.currentWordIndex] = event.word;
    // Find the next index
    int nextIndex = wordsList.indexWhere((element) => element == null);
    if (nextIndex == -1) {
      nextIndex += 1;
    }

    // Yield a new state
    yield state.copyWith(
      wordsList: wordsList,
      currentWordIndex: nextIndex,
      isMnemonicValid: bip39.validateMnemonic(wordsList.join(" ")),
    );
  }

  Stream<RecoverAccountState> _mapChangeFocusEventToState(
    ChangeFocus event,
  ) async* {
    yield state.copyWith(currentWordIndex: event.focusedField);
  }
}
