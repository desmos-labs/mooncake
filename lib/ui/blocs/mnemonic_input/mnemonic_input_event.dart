import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents a generic event related to the mnemonic input.
abstract class MnemonicInputEvent extends Equatable {
  const MnemonicInputEvent();

  @override
  List<Object> get props => [];
}

/// Event that is emitted every time the input mnemonic changes.
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
  String toString() => 'MnemonicChanged';
}

/// Event that is emitted when the input must be reset.
class Reset extends MnemonicInputEvent {
  @override
  String toString() => 'Reset';
}
