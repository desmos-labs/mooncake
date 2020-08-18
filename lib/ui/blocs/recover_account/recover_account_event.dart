import 'package:equatable/equatable.dart';

/// Represents a generic event that is emitted when recovering an existing
/// account using a mnemonic phrase.
abstract class RecoverAccountEvent extends Equatable {
  const RecoverAccountEvent();

  @override
  List<Object> get props => [];
}

/// Tells the Bloc to reset the current state.
class ResetRecoverAccountState extends RecoverAccountEvent {
  @override
  String toString() => 'ResetRecoverAccountState';
}

/// Event that is emitted when a word is being emitted when a new word of
/// the mnemonic if being typed from the user.
class TypeWord extends RecoverAccountEvent {
  final int index;
  final String word;

  TypeWord(this.index, this.word)
      : assert(index != null),
        assert(word != null);

  @override
  List<Object> get props => [index, word];
}

/// Event that is emitted when a word is selected from the user as the next
/// word that compose its mnemonic code.
class WordSelected extends RecoverAccountEvent {
  final String word;

  WordSelected(this.word) : assert(word != null);

  @override
  List<Object> get props => [word];
}

/// Tells the Bloc that the focus has changed to the word having the given
/// index.
class ChangeFocus extends RecoverAccountEvent {
  final String currentText;
  final int focusedField;

  ChangeFocus(this.focusedField, this.currentText);

  @override
  List<Object> get props => [focusedField, currentText];
}

/// Tells the Bloc that the focus has changed to the word having the given
/// index.
class TurnOffBackupPopup extends RecoverAccountEvent {}
