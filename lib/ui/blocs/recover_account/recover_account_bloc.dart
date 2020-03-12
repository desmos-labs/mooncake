import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:bip39/bip39.dart' as bip39;

/// Bloc that allows to properly handle the recovering account events
/// and emits the correct states.
class RecoverAccountBloc
    extends Bloc<RecoverAccountEvent, RecoverAccountState> {
  final FirebaseAnalytics _analytics;

  RecoverAccountBloc({
    @required FirebaseAnalytics analytics,
  })  : assert(analytics != null),
        _analytics = analytics;

  factory RecoverAccountBloc.create(BuildContext context) {
    return RecoverAccountBloc(
      analytics: Injector.get(),
    );
  }

  @override
  RecoverAccountState get initialState => TypingMnemonic.initial();

  @override
  Stream<RecoverAccountState> mapEventToState(
    RecoverAccountEvent event,
  ) async* {
    if (event is TypeWord) {
      yield* _mapTypeWordEventToState(event);
    } else if (event is WordSelected) {
      yield* _mapWordSelectedEventToState(event);
    } else if (event is ChangeFocus) {
      yield* _mapChangeFocusEventToState(event);
    } else if (event is RecoverAccount) {
      yield* _mapRecoverAccountToState();
    } else if (event is CloseErrorPopup) {
      yield* _mapCloseErrorPopupToState();
    }
  }

  Stream<RecoverAccountState> _mapTypeWordEventToState(TypeWord event) async* {
    final currentState = state;
    if (currentState is TypingMnemonic) {
      yield currentState.copyWith(typedWord: event.word);
    }
  }

  Stream<RecoverAccountState> _mapWordSelectedEventToState(
    WordSelected event,
  ) async* {
    final currentState = state;
    if (currentState is TypingMnemonic) {
      // Update the words list
      final wordsList = currentState.wordsList;
      wordsList[currentState.currentWordIndex] = event.word;

      // Find the next index
      final nextIndex = wordsList.indexWhere((element) => element == null);

      // Yield a new state
      yield currentState.copyWith(
        typedWord: "",
        wordsList: wordsList,
        currentWordIndex: nextIndex,
        isMnemonicValid: bip39.validateMnemonic(wordsList.join(" ")),
      );
    }
  }

  Stream<RecoverAccountState> _mapChangeFocusEventToState(
    ChangeFocus event,
  ) async* {
    final currentState = state;
    if (currentState is TypingMnemonic) {
      yield currentState.copyWith(
        typedWord: event.currentText,
        currentWordIndex: event.focusedField,
      );
    }
  }

  Stream<RecoverAccountState> _mapRecoverAccountToState() async* {
    // TODO: Implement this again
  }

  Stream<RecoverAccountState> _mapCloseErrorPopupToState() async* {
    // TODO: Implement this again
  }
}
