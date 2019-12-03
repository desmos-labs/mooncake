import 'package:equatable/equatable.dart';

abstract class MnemonicInputEvent extends Equatable {
  const MnemonicInputEvent();
}

class MnemonicChanged extends MnemonicInputEvent {
  final String mnemonic;

  MnemonicChanged(this.mnemonic);

  @override
  List<Object> get props => [mnemonic];

  @override
  String toString() => 'MnemonicChanged { mnemonic: $mnemonic }';
}

class Reset extends MnemonicInputEvent {
  @override
  String toString() => 'Reset';
}
