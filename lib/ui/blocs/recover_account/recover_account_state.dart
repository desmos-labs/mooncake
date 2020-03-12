import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents a generic state for the account recovery screen.
abstract class RecoverAccountState extends Equatable {
  const RecoverAccountState();

  @override
  List<Object> get props => [];
}

/// Represents the state during which the user is still typing it's mnemonic.
class TypingMnemonic extends RecoverAccountState {
  final int currentWordIndex;

  /// Represents the word that is being typed.
  final String typedWord;

  /// Represents the list of words that have been selected as composing the
  /// mnemonic.
  final List<String> wordsList;

  /// Tells is the mnemonic inserted till now is valid or not.
  final bool isMnemonicValid;

  TypingMnemonic({
    @required this.currentWordIndex,
    @required this.typedWord,
    @required this.wordsList,
    @required this.isMnemonicValid,
  })  : assert(typedWord != null),
        assert(wordsList != null);

  factory TypingMnemonic.initial() {
    return TypingMnemonic(
      currentWordIndex: 0,
      typedWord: "",
      wordsList: List(24),
      isMnemonicValid: false,
    );
  }

  TypingMnemonic copyWith({
    int currentWordIndex,
    String typedWord,
    List<String> wordsList,
    bool isMnemonicValid,
  }) {
    return TypingMnemonic(
      currentWordIndex: currentWordIndex ?? this.currentWordIndex,
      typedWord: typedWord ?? this.typedWord,
      wordsList: wordsList ?? this.wordsList,
      isMnemonicValid: isMnemonicValid ?? this.isMnemonicValid,
    );
  }

  @override
  List<Object> get props => [
        currentWordIndex,
        typedWord,
        wordsList,
        isMnemonicValid,
      ];

  @override
  String toString() => 'TypingMnemonic { '
      'currentWordIndex: $currentWordIndex, '
      'typedWord: $typedWord, '
      'wordsList: $wordsList ,'
      'isMnemonicValid: $isMnemonicValid '
      '}';
}

/// Represents the state in which the mnemonic is being used to recover
/// the account associated with it.
class RecoveringAccount extends RecoverAccountState {
  @override
  String toString() => "RecoveringAccount";
}

/// Represents the state in which the application goes if the account has been
/// recovered successfully.
class RecoveredAccount extends RecoverAccountState {
  final String mnemonic;

  RecoveredAccount(this.mnemonic);

  @override
  List<Object> get props => [mnemonic];

  @override
  String toString() => "RecoveredAccount";
}

/// Represents the state in which the account has not been recovered due to an
/// error.
class RecoverError extends RecoverAccountState {
  final dynamic error;

  RecoverError(this.error);

  @override
  List<Object> get props => [error];

  @override
  String toString() => "RecoverError { error: $error }";
}
