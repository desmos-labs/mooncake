import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:mooncake/usecases/usecases.dart';

/// Bloc that allows to properly handle the recovering account events
/// and emits the correct states.
class RecoverAccountBloc
    extends Bloc<RecoverAccountEvent, RecoverAccountState> {
  final CanUseBiometricsUseCase _canUseBiometricsUseCase;
  final NavigatorBloc _navigatorBloc;

  RecoverAccountBloc({
    @required CanUseBiometricsUseCase canUseBiometricsUseCase,
    @required NavigatorBloc navigatorBloc,
  })  : assert(canUseBiometricsUseCase != null),
        _canUseBiometricsUseCase = canUseBiometricsUseCase,
        assert(navigatorBloc != null),
        _navigatorBloc = navigatorBloc;

  factory RecoverAccountBloc.create(BuildContext context) {
    return RecoverAccountBloc(
      canUseBiometricsUseCase: Injector.get(),
      navigatorBloc: BlocProvider.of(context),
    );
  }

  @override
  RecoverAccountState get initialState => RecoverAccountState.initial();

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
    } else if (event is ContinueRecovery) {
      _handleContinueRecovery();
    }
  }

  Stream<RecoverAccountState> _mapTypeWordEventToState(TypeWord event) async* {
    final wordsList = List<String>()..addAll(state.wordsList);
    wordsList[state.currentWordIndex] = event.word;
    yield state.copyWith(
      wordsList: wordsList,
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

  void _handleContinueRecovery() async {
    final canUseBio = await _canUseBiometricsUseCase.check();
    if (canUseBio) {
      _navigatorBloc.add(NavigateToEnableBiometrics());
    } else {
      _navigatorBloc.add(NavigateToSetPassword());
    }
  }
}
