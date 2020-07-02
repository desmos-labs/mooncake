import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents a generic event that can be emitted from withing the mnemonic
/// screen.
@immutable
abstract class MnemonicEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// Tells the Bloc to load the mnemonic and show it.
class ShowMnemonic extends MnemonicEvent {}

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

/// Hides mnemonic backup popup
class HideBackupMnemonicPhrasePopup extends MnemonicEvent {}

/// Initial check to see if backup popup needs to be shown
class ValidateBackupMnemonicPopupState extends MnemonicEvent {}

/// Turns off backup popup permission and prevents future backup popups from showing
class TurnOffBackupMnemonicPopupPermission extends MnemonicEvent {}
