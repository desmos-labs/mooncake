import 'package:equatable/equatable.dart';

/// Represents the login status of the user using the application.
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

/// Tells the view to display a screen while the application is trying
/// to figure out whether the user is logged in or not.
class Loading extends LoginState {
  @override
  String toString() => 'Loading';
}

/// Tells the view that the user is not logged in and thus the login
/// screen should be shown to him.
class LoggedOut extends LoginState {
  @override
  String toString() => 'LoggedOut';
}

/// Tells the view that the user is logged in and thus he can properly
/// access the main page of the application.
class LoggedIn extends LoginState {
  @override
  String toString() => 'LoggedIn';
}
