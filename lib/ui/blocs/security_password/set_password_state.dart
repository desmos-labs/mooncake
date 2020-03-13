import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum PasswordSecurity { UNKNOWN, LOW, MEDIUM, HIGH }

/// Represents the state of the screen that allows the user to set a custom
/// password to protect his account.
class SetPasswordState extends Equatable {
  /// Represents the currently input password.
  final String inputPassword;

  /// Tells whether the password is valid or not.
  bool get isPasswordValid => inputPassword.length >= 6;

  /// Indicates the security of the password.
  final PasswordSecurity passwordSecurity;

  const SetPasswordState({
    @required this.inputPassword,
    @required this.passwordSecurity,
  });

  factory SetPasswordState.initial() {
    return SetPasswordState(
      inputPassword: "",
      passwordSecurity: PasswordSecurity.UNKNOWN,
    );
  }

  SetPasswordState copyWith({
    String inputPassword,
    PasswordSecurity passwordSecurity,
  }) {
    return SetPasswordState(
      inputPassword: inputPassword ?? this.inputPassword,
      passwordSecurity: passwordSecurity ?? this.passwordSecurity,
    );
  }

  @override
  List<Object> get props => [inputPassword, passwordSecurity];

  @override
  String toString() => 'SetPasswordState { '
      'inputPassword: $inputPassword, '
      'passwordSecurity: $passwordSecurity'
      '}';
}
