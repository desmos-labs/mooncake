import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
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

  /// Indicates whether the account is being refreshed or not.
  final bool refreshing;

  final List<MooncakeAccount> accounts;

  LoggedIn({
    @required this.user,
    @required this.refreshing,
    @required this.accounts,
  });

  factory LoggedIn.initial(
    MooncakeAccount user,
    List<MooncakeAccount> accounts,
  ) {
    return LoggedIn(
      user: user,
      refreshing: false,
      accounts: accounts,
    );
  }

  List<MooncakeAccount> get otherAccounts {
    return accounts.where((x) => x.address != user.address).toList();
  }

  LoggedIn copyWith({
    MooncakeAccount user,
    bool refreshing,
    List<MooncakeAccount> accounts,
  }) {
    return LoggedIn(
      user: user ?? this.user,
      refreshing: refreshing ?? this.refreshing,
      accounts: accounts ?? this.accounts,
    );
  }

  @override
  List<Object> get props {
    return [
      user,
      refreshing,
      accounts,
    ];
  }

  @override
  String toString() {
    return 'LoggedIn { '
        'user: $user, '
        'refreshing: $refreshing, '
        'accounts: $accounts '
        '}';
  }
}

/// Represents the state during which the account is being generated while loggedin.
class CreatingAccountWhileLoggedIn extends LoggedIn {
  /// Represents the currently used account.
  @override
  final MooncakeAccount user;

  /// Indicates whether the account is being refreshed or not.
  @override
  final bool refreshing;

  @override
  final List<MooncakeAccount> accounts;

  CreatingAccountWhileLoggedIn({
    this.user,
    this.accounts,
    this.refreshing,
  }) : super(
          user: user,
          accounts: accounts,
          refreshing: refreshing,
        );

  @override
  List<Object> get props {
    return [
      user,
      accounts,
      refreshing,
    ];
  }

  @override
  String toString() {
    return 'CreatingAccountWhileLoggedIn { '
        'user: $user, '
        'refreshing: $refreshing, '
        'accounts: $accounts '
        '}';
  }
}

/// Tells the view that a new account has been generated while logged in
class AccountCreatedWhileLoggedIn extends LoggedIn {
  final List<String> mnemonic;

  /// Represents the currently used account.
  @override
  final MooncakeAccount user;

  /// Indicates whether the account is being refreshed or not.
  @override
  final bool refreshing;

  @override
  final List<MooncakeAccount> accounts;

  AccountCreatedWhileLoggedIn(
    this.mnemonic, {
    this.user,
    this.accounts,
    this.refreshing,
  }) : super(
          user: user,
          accounts: accounts,
          refreshing: refreshing,
        );

  @override
  List<Object> get props {
    return [
      mnemonic,
      user,
      accounts,
      refreshing,
    ];
  }

  @override
  String toString() {
    return 'AccountCreatedWhileLoggedIn { '
        'user: $user, '
        'refreshing: $refreshing, '
        'accounts: $accounts, '
        'mnemonic: $mnemonic '
        '}';
  }
}
