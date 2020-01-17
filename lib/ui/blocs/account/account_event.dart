import 'package:equatable/equatable.dart';
import 'package:mooncake/entities/entities.dart';

/// Represents a generic event that is emitted from the account data screen
abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

/// Represents the event that is emitted when the account data need to
/// be loaded.
class LoadAccount extends AccountEvent {
  @override
  String toString() => 'LoadAccount';
}

/// Event that is loaded once the address has been successfully computed.
class AddressLoaded extends AccountEvent {
  final AccountData account;

  AddressLoaded(this.account);

  @override
  String toString() => 'AddressLoaded { address: $account }';

  @override
  List<Object> get props => [account];
}
