import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents a generic event that can be emitted from withing the mnemonic
/// screen.
@immutable
abstract class MnemonicEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// Tells the Bloc to load the mnemonic and show it.
class ShowMnemonic extends MnemonicEvent {
  @override
  String toString() => 'ShowMnemonic';
}
