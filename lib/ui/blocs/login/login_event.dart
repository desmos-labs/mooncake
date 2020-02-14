import 'package:equatable/equatable.dart';

/// Represents a generic event that is emitted during the login procedure.
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

/// Tells the block to check for the current user status to know if
/// he is already logged in or not.
class CheckStatus extends LoginEvent {
  @override
  String toString() => 'CheckStatus';
}

/// Tells the bloc to log in the user showing him the home screen.
class LogIn extends LoginEvent {
  final String mnemonic;

  LogIn(this.mnemonic);

  @override
  List<Object> get props => [mnemonic];

  @override
  String toString() => 'LogIn';
}

class LogOut extends LoginEvent {
  @override
  String toString() => 'LogOut';
}
