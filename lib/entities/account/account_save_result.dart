import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents the result of the action of editing the account.
class AccountSaveResult extends Equatable {
  final bool success;
  final String error;

  AccountSaveResult({
    @required this.success,
    @required this.error,
  }) : assert(success != null);

  factory AccountSaveResult.success() {
    return AccountSaveResult(success: true, error: null);
  }

  factory AccountSaveResult.error(String error) {
    return AccountSaveResult(success: false, error: error);
  }

  @override
  List<Object> get props {
    return [success, error];
  }
}
