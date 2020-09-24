import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mooncake/entities/entities.dart';

/// Represents a generic event that is emitted when the user wants to
/// navigate from a screen to another one.
abstract class NavigatorEvent extends Equatable {
  const NavigatorEvent();

  @override
  List<Object> get props => [];
}

/// Tells the Bloc to go back one page
class GoBack extends NavigatorEvent {
  final dynamic result;

  GoBack([this.result]);
}

/// Tells the Bloc to navigate to the home screen.
class NavigateToHome extends NavigatorEvent {}

/// Tells the Bloc to navigate to the screen that allows to recover
/// an existing account using a mnemonic phrase.
class NavigateToRecoverAccount extends NavigatorEvent {}

/// Tells the Bloc to navigate to the screen that allows the user to
/// import a mnemonic backup.
class NavigateToRestoreBackup extends NavigatorEvent {}

/// Tells the Bloc to navigate either to the password or biometric setting
/// screen in order to protect the account.
class NavigateToProtectAccount extends NavigatorEvent {}

/// Tells the Bloc to navigate to the screen that allows the user
/// to set a biometric authentication.
class NavigateToEnableBiometrics extends NavigatorEvent {}

/// Tells the Bloc to navigate to the screen that allows the user
/// to set a password to protect the account.
class NavigateToSetPassword extends NavigatorEvent {}

/// Tells the Bloc to navigate to the screen that allows the user
/// to create a new post.
class NavigateToCreatePost extends NavigatorEvent {
  final Post parentPost;

  NavigateToCreatePost([this.parentPost]);

  @override
  List<Object> get props => [parentPost];

  @override
  String toString() => 'NavigateToCreatePost { parent: $parentPost }';
}

/// Tells the Bloc to navigate to the screen that displays the post
/// having the specified id.
class NavigateToPostDetails extends NavigatorEvent {
  final String postId;

  NavigateToPostDetails(this.postId);

  @override
  String toString() => 'NavigateToPostDetails { postId: $postId }';
}

/// Tells the Bloc to navigate to the wallet screen.
class NavigateToWallet extends NavigatorEvent {}

/// Tells the Bloc to navigate to the screen that allows to show the mnemonic.
/// Takes an optional argument [backupPhrase] in the event that this is a backup and not an export event
class NavigateToShowMnemonicAuth extends NavigatorEvent {
  final bool backupPhrase;
  final String address;
  NavigateToShowMnemonicAuth(this.address, {this.backupPhrase = false});

  @override
  List<Object> get props => [address, backupPhrase];
}

/// Tells the Bloc to navigate to the page that allows the user
/// to export his previously encrypted mnemonic data.
class NavigateToExportMnemonic extends NavigatorEvent {
  final MnemonicData mnemonicData;

  NavigateToExportMnemonic({@required this.mnemonicData});

  @override
  List<Object> get props => [mnemonicData];
}

// ____________________________________________

/// Tells the Bloc to navigate to the screen that allows the user to
/// edit his account.
class NavigateToEditAccount extends NavigatorEvent {}

/// ShowAccountDetails tells the Bloc to navigate to the screen that
/// displays the details of the user.
class NavigateToUserDetails extends NavigatorEvent {
  final User user;

  NavigateToUserDetails(this.user);

  @override
  List<Object> get props => [user];
}

/// Tells the Bloc to navigate to the screen that asks for confirmation of their mnemonic phrase
class NavigateToConfirmMnemonicBackupPhrase extends NavigatorEvent {}

/// Tells the Bloc to navigate to the lightbox screen
class NavigateToLightbox extends NavigatorEvent {
  final List<PostMedia> photos;
  final int selectedIndex;

  NavigateToLightbox({
    @required this.photos,
    @required this.selectedIndex,
  });

  @override
  List<Object> get props => [photos, selectedIndex];
}
