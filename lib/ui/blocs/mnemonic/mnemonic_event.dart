import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents a generic event that can be emitted from withing the mnemonic
/// screen.
@immutable
abstract class MnemonicEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// Tells the Bloc that the user has toggled the check box that
/// is required to make sure he has read the warnings before
/// being able to view his mnemonic.
class ToggleCheckBox extends MnemonicEvent {}

/// Tells the Bloc to load the mnemonic and show it.
class ShowMnemonic extends MnemonicEvent {
  final String address;
  ShowMnemonic(this.address);
  @override
  List<Object> get props => [address];
}

/// Tells the Bloc to show the export popup.
class ShowExportPopup extends MnemonicEvent {}

/// Tells the Bloc to close the export popup.
class CloseExportPopup extends MnemonicEvent {}

/// Tells the Bloc that the user has changed the password which which to
/// encrypt the mnemonic.
class ChangeEncryptPassword extends MnemonicEvent {
  final String password;

  ChangeEncryptPassword(this.password);

  @override
  List<Object> get props => [password];
}

/// Tells the Bloc to export the mnemonic.
class ExportMnemonic extends MnemonicEvent {}
