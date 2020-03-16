import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum PasswordSecurity { UNKNOWN, LOW, MEDIUM, HIGH }

/// Represents the state of the screen that allows the user to set a custom
/// password to protect his account.
class SetPasswordState extends Equatable {
  /// Tells whether the password should be shown or not.
  final bool showPassword;

  /// Represents the currently input password.
  final String inputPassword;

  /// Tells whether the password is valid or not.
  bool get isPasswordValid => inputPassword.length >= 6;

  /// Indicates the security of the password.
  final PasswordSecurity passwordSecurity;

  /// Tells whether or not the password is being saved.
  final bool savingPassword;

  const SetPasswordState({
    @required this.showPassword,
    @required this.inputPassword,
    @required this.passwordSecurity,
    @required this.savingPassword,
  });

  factory SetPasswordState.initial() {
    return SetPasswordState(
      showPassword: false,
      inputPassword: "",
      passwordSecurity: PasswordSecurity.UNKNOWN,
      savingPassword: false,
    );
  }

  SetPasswordState copyWith({
    bool showPassword,
    String inputPassword,
    PasswordSecurity passwordSecurity,
    bool savingPassword,
  }) {
    return SetPasswordState(
      showPassword: showPassword ?? this.showPassword,
      inputPassword: inputPassword ?? this.inputPassword,
      passwordSecurity: passwordSecurity ?? this.passwordSecurity,
      savingPassword: savingPassword ?? this.savingPassword,
    );
  }

  @override
  List<Object> get props => [
        showPassword,
        inputPassword,
        passwordSecurity,
        savingPassword,
      ];

  @override
  String toString() => 'SetPasswordState { '
      'showPassword: $showPassword, '
      'passwordSecurity: $passwordSecurity, '
      'savingPassword: $savingPassword '
      '}';
}
