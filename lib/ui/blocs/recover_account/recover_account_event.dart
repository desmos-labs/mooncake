import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents a generic event that is emitted when recovering an existing
/// account using a mnemonic phrase.
abstract class RecoverAccountEvent extends Equatable {
  const RecoverAccountEvent();

  @override
  List<Object> get props => [];
}

/// Event that is emitted when a word is being emitted when a new word of
/// the mnemonic if being typed from the user.
class TypeWord extends RecoverAccountEvent {
  final String word;

  TypeWord(this.word) : assert(word != null);

  @override
  List<Object> get props => [word];

  @override
  String toString() => 'TypeWord { word: $word }';
}

/// Event that is emitted when a word is selected from the user as the next
/// word that compose its mnemonic code.
class WordSelected extends RecoverAccountEvent {
  final String word;

  WordSelected(this.word) : assert(word != null);

  @override
  List<Object> get props => [word];

  @override
  String toString() => 'WordSelected { word: $word }';
}

/// Tells the BLoC that the focus has changed to the word having the given
/// index.
class ChangeFocus extends RecoverAccountEvent {
  final String currentText;
  final int focusedField;

  ChangeFocus(this.focusedField, this.currentText);

  @override
  List<Object> get props => [focusedField, currentText];

  @override
  String toString() => 'ChangeFocus { '
      'focusedField: $focusedField, '
      'currentText: $currentText '
      '}';
}

/// Event that tells the bloc that the user has clicked the button to recover
/// the account using the mnemonic phrase inserted.
class RecoverAccount extends RecoverAccountEvent {
  @override
  String toString() => 'RecoverAccount';
}

/// Event that is emitted when the user wants to close the error popup.
class CloseErrorPopup extends RecoverAccountEvent {
  @override
  String toString() => 'CloseErrorPopup';
}
