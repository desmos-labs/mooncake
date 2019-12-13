import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents a generic state for screen that shows the user
/// the details about his account.
abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object> get props => [];
}

/// Represents the state where the user account has not yet been
/// initialized and thus must be loaded.
class UninitializedAccount extends AccountState {
  @override
  String toString() => 'UninitializedAccountState';
}

/// Represents the state in which the user account data
/// are being properly loaded.
class LoadingAccount extends AccountState {
  @override
  String toString() => 'LoadingAccountState';
}

/// Represents the state in which the user data has been
/// properly loaded.
class AccountLoaded extends AccountState {
  final String address;

  AccountLoaded({@required this.address});
}
