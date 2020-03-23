import 'package:equatable/equatable.dart';
import 'package:mooncake/entities/entities.dart';

/// Represents the login status of the user using the application.
abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object> get props => [];
}

/// Tells the view to display a screen while the application is trying
/// to figure out whether the user is logged in or not.
class Loading extends AccountState {
  @override
  String toString() => 'Loading';
}

/// Tells the view that the user is not logged in and thus the login
/// screen should be shown to him.
class LoggedOut extends AccountState {
  @override
  String toString() => 'LoggedOut';
}

/// Represents the state during which the account is being generated.
class CreatingAccount extends LoggedOut {
  @override
  String toString() => 'CreatingAccount';
}

/// Tells the view that the account has been generated properly and
/// the user can log into the application.
class AccountCreated extends LoggedOut {
  final List<String> mnemonic;

  AccountCreated(this.mnemonic);

  @override
  List<Object> get props => [mnemonic];

  @override
  String toString() => 'AccountCreated';
}

/// Tells the view that the user is logged in and thus he can properly
/// access the main page of the application.
class LoggedIn extends AccountState {
  /// Represents the currently used account.
  final MooncakeAccount user;

  LoggedIn(this.user);

  @override
  String toString() => 'LoggedIn { user: $user }';
}


