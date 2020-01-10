import 'package:equatable/equatable.dart';

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
