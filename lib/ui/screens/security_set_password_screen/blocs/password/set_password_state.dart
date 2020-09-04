import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:password_strength/password_strength.dart';
import 'package:mooncake/ui/ui.dart';

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
  PasswordSecurity get passwordSecurity {
    if (inputPassword == null) {
      return PasswordSecurity.UNKNOWN;
    }

    final strength = estimatePasswordStrength(inputPassword);
    var security = PasswordSecurity.UNKNOWN;
    if (strength < 0.50) {
      security = PasswordSecurity.LOW;
    } else if (strength < 0.75) {
      security = PasswordSecurity.MEDIUM;
    } else {
      security = PasswordSecurity.HIGH;
    }
    return security;
  }

  /// Tells whether or not the password is being saved.
  final bool savingPassword;

  const SetPasswordState({
    @required this.showPassword,
    @required this.inputPassword,
    @required this.savingPassword,
  });

  factory SetPasswordState.initial() {
    return SetPasswordState(
      showPassword: false,
      inputPassword: '',
      savingPassword: false,
    );
  }

  SetPasswordState copyWith({
    bool showPassword,
    String inputPassword,
    bool savingPassword,
  }) {
    return SetPasswordState(
      showPassword: showPassword ?? this.showPassword,
      inputPassword: inputPassword ?? this.inputPassword,
      savingPassword: savingPassword ?? this.savingPassword,
    );
  }

  @override
  List<Object> get props => [
        showPassword,
        inputPassword,
        savingPassword,
      ];

  @override
  String toString() => 'SetPasswordState { '
      'showPassword: $showPassword, '
      'savingPassword: $savingPassword '
      '}';
}
