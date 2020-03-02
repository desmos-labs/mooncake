import 'package:equatable/equatable.dart';
import 'package:mooncake/entities/entities.dart';

/// Represents a generic event that is emitted during the login procedure.
abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

/// Tells the block to check for the current user status to know if
/// he is already logged in or not.
class CheckStatus extends AccountEvent {
  @override
  String toString() => 'CheckStatus';
}

/// Tells the bloc to log in the user showing him the home screen.
class LogIn extends AccountEvent {
  final String mnemonic;

  LogIn(this.mnemonic);

  @override
  List<Object> get props => [mnemonic];
}

/// Tells the BLoC to refresh the currently saved account replacing it
/// with the new one.
class Refresh extends AccountEvent {
  final User user;

  Refresh(this.user);

  @override
  List<Object> get props => [user];
}

class LogOut extends AccountEvent {
  @override
  String toString() => 'LogOut';
}
