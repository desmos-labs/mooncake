import 'package:equatable/equatable.dart';

/// Represents a generic event emitted during the generation of a new
/// mnemonic phrase.
abstract class GenerateMnemonicEvent extends Equatable {
  const GenerateMnemonicEvent();

  @override
  List<Object> get props => [];
}

/// Tells the bloc to start generating a new mnemonic.
class GenerateMnemonic extends GenerateMnemonicEvent {
  @override
  String toString() => 'GenerateMnemonic';
}

/// Tells the bloc that the user has written down the mnemonic and he can
/// then be directed to verification screen.
class MnemonicWritten extends GenerateMnemonicEvent {
  @override
  String toString() => 'MnemonicWritten';
}
