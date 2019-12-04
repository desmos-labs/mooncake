import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class MnemonicInputEvent extends Equatable {
  const MnemonicInputEvent();
}

class MnemonicChanged extends MnemonicInputEvent {
  final String verificationMnemonic;
  final String insertedMnemonic;

  MnemonicChanged({
    @required this.insertedMnemonic,
    @required this.verificationMnemonic,
  });

  @override
  List<Object> get props => [insertedMnemonic];

  @override
  String toString() => 'MnemonicChanged { '
      'mnemonic: $insertedMnemonic, '
      'verificationMnemonic: $verificationMnemonic '
      '}';
}

class Reset extends MnemonicInputEvent {
  @override
  String toString() => 'Reset';
}
