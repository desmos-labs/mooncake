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

/// Tells the view that the user is logged in and thus he can properly
/// access the main page of the application.
class LoggedIn extends AccountState {
  /// Represents the currently used account.
  final User user;

  LoggedIn(this.user);

  @override
  String toString() => 'LoggedIn { user: $user }';
}
