import 'package:equatable/equatable.dart';

/// Represents the current state of the mnemonic generation screen.
abstract class GenerateMnemonicState extends Equatable {
  const GenerateMnemonicState();

  @override
  List<Object> get props => [];
}

/// The mnemonic is being generated.
class GeneratingMnemonic extends GenerateMnemonicState {
  @override
  String toString() => 'GeneratingMnemonic';
}

/// The mnemonic has been generated and can be displayed.
class MnemonicGenerated extends GenerateMnemonicState {
  final List<String> mnemonic;

  MnemonicGenerated(this.mnemonic);

  @override
  List<Object> get props => [mnemonic];

  @override
  String toString() => 'MnemonicGenerated';
}
