import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mooncake/entities/posts/post.dart';

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

  @override
  String toString() => 'GoBack';
}

/// Tells the Bloc to navigate to the home screen.
class NavigateToHome extends NavigatorEvent {
  @override
  String toString() => 'NavigateToHome';
}

/// Tells the Bloc to navigate to the screen that allows to recover
/// an existing account using a mnemonic phrase.
class NavigateToRecoverAccount extends NavigatorEvent {
  @override
  String toString() => 'NavigateToRecoverAccount';
}

/// Tells the Bloc to navigate either to the password or biometric setting
/// screen in order to protect the account.
class NavigateToProtectAccount extends NavigatorEvent {
  @override String toString() => 'NavigateToProtectAccount';
}

/// Tells the Bloc to navigate to the screen that allows the user
/// to set a biometric authentication.
class NavigateToEnableBiometrics extends NavigatorEvent {
  @override
  String toString() => 'NavigateToEnableBiometrics';
}

/// Tells the Bloc to navigate to the screen that allows the user
/// to set a password to protect the account.
class NavigateToSetPassword extends NavigatorEvent {
  @override
  String toString() => 'NavigateToSetPassword';
}

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
  final BuildContext context;
  final String postId;

  NavigateToPostDetails(this.context, this.postId);

  @override
  String toString() => 'NavigateToPostDetails { postId: $postId }';
}

/// Tells the Bloc to navigate to the wallet screen.
class NavigateToWallet extends NavigatorEvent {
  @override
  String toString() => 'NavigateToWallet';
}

/// Tells the Bloc to navigate to the screen that allows to show the mnemonic.
class NavigateToShowMnemonic extends NavigatorEvent {
  @override
  String toString() => 'NavigateToShowMnemonic';
}
