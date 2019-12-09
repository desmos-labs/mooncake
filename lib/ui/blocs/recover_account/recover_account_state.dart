import 'package:desmosdemo/ui/ui.dart';
import 'package:equatable/equatable.dart';

abstract class RecoverAccountState extends Equatable {
  const RecoverAccountState();

  @override
  List<Object> get props => [];
}

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

class RecoveringAccount extends RecoverAccountState {
  @override
  String toString() => "RecoveringAccount";
}

class RecoveredAccount extends RecoverAccountState {
  final String mnemonic;

  RecoveredAccount(this.mnemonic);

  @override
  List<Object> get props => [mnemonic];

  @override
  String toString() => "RecoveredAccount";
}
