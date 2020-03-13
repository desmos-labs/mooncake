import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

/// Represents a generic event that is emitted when the user wants to
/// navigate from a screen to another one.
abstract class NavigatorEvent extends Equatable {
  const NavigatorEvent();

  @override
  List<Object> get props => [];
}

/// Tells the BLoC to navigate to the home screen.
class NavigateToHome extends NavigatorEvent {
  @override
  String toString() => 'NavigateToHome';
}

/// Tells the BLoC to navigate to the screen that allows to recover
/// an existing account using a mnemonic phrase.
class NavigateToRecoverAccount extends NavigatorEvent {
  @override
  String toString() => 'NavigateToRecoverAccount';
}

/// Tells the BLoC to navigate to the screen that allows the user
/// to set a biometric authentication.
class NavigateToEnableBiometrics extends NavigatorEvent {
  @override
  String toString() => 'NavigateToEnableBiometrics';
}

/// Tells the BLoC to navigate to the screen that allows the user
/// to set a password to protect the account.
class NavigateToSetPassword extends NavigatorEvent {
  @override
  String toString() => 'NavigateToSetPassword';
}

/// Tells the BLoC to navigate to the screen that displays the post
/// having the specified id.
class NavigateToPostDetails extends NavigatorEvent {
  final BuildContext context;
  final String postId;

  NavigateToPostDetails(this.context, this.postId);

  @override
  String toString() => 'NavigateToPostdetail { postId: $postId }';
}

/// Tells the BLoC to navigate to the wallet screen.
class NavigateToWallet extends NavigatorEvent {
  @override
  String toString() => 'NavigateToWallet';
}
