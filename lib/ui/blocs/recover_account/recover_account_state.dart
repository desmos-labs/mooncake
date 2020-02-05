import 'package:mooncake/ui/ui.dart';
import 'package:equatable/equatable.dart';

/// Represents a generic state for the account recovery screen.
abstract class RecoverAccountState extends Equatable {
  const RecoverAccountState();

  @override
  List<Object> get props => [];
}

/// Represents the state in which the user is typing his mnemonic into
/// the proepr text field.
class TypingMnemonic extends RecoverAccountState {
  final MnemonicInputState mnemonicInputState;

  TypingMnemonic(this.mnemonicInputState);

  @override
  List<Object> get props => [mnemonicInputState];

  @override
  String toString() {
    return 'TypingMnemonic { mnemonicInputState: $mnemonicInputState }';
  }
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
