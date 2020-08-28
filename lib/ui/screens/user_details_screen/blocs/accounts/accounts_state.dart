import 'package:equatable/equatable.dart';
import 'package:mooncake/entities/entities.dart';

/// All accounts status
class AccountsState extends Equatable {
  final List<MooncakeAccount> accounts;

  const AccountsState({
    this.accounts,
  });

  factory AccountsState.initial() {
    return AccountsState(
      accounts: [],
    );
  }

  AccountsState copyWith({
    List<MooncakeAccount> accounts,
  }) {
    return AccountsState(
      accounts: accounts ?? this.accounts,
    );
  }

  @override
  String toString() => 'AccountsState { '
      'accounts: $accounts '
      ' }';

  @override
  List<Object> get props => [accounts];
}
