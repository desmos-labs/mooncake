import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents the state during which the user is still typing it's mnemonic.
class RecoverAccountState extends Equatable {
  /// Represents the currently focused word.
  final int currentWordIndex;

  /// Represents the word that is being typed.
  String get typedWord => wordsList[currentWordIndex] ?? '';

  /// Represents the list of words that have been selected as composing the
  /// mnemonic.
  final List<String> wordsList;

  /// Tells whether the mnemonic is all complete or not.
  bool get isMnemonicComplete => wordsList.where((e) => e == null).isEmpty;

  /// Tells is the mnemonic inserted till now is valid or not.
  final bool isMnemonicValid;

  RecoverAccountState({
    @required this.currentWordIndex,
    @required this.wordsList,
    @required this.isMnemonicValid,
  }) : assert(wordsList != null);

  factory RecoverAccountState.initial() {
    return RecoverAccountState(
      currentWordIndex: 0,
      wordsList: List(24),
      isMnemonicValid: false,
    );
  }

  RecoverAccountState copyWith({
    int currentWordIndex,
    List<String> wordsList,
    bool isMnemonicValid,
  }) {
    return RecoverAccountState(
      currentWordIndex: currentWordIndex ?? this.currentWordIndex,
      wordsList: wordsList ?? this.wordsList,
      isMnemonicValid: isMnemonicValid ?? this.isMnemonicValid,
    );
  }

  @override
  List<Object> get props => [
        currentWordIndex,
        wordsList,
        isMnemonicValid,
      ];

  @override
  String toString() => 'TypingMnemonic { '
      'currentWordIndex: $currentWordIndex, '
      'isMnemonicValid: $isMnemonicValid '
      '}';
}
