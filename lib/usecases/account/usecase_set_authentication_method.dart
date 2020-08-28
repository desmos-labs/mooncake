import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to save an authentication method as the user local authentication.
class SetAuthenticationMethodUseCase {
  final UserRepository _userRepository;

  SetAuthenticationMethodUseCase({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  /// Sets the authentication method of the account having
  /// the given [address] to be biometric.
  Future<void> biometrics(String address) {
    return _userRepository.saveAuthenticationMethod(
        address, BiometricAuthentication());
  }

  /// Sets the authentication method of the account having the
  /// given [address] to be password-based.
  /// Before storing it locally, the given [clearTextPassword] is hashed
  /// for security purpose.
  Future<void> password(String address, String clearTextPassword) {
    final bytes = utf8.encode(clearTextPassword);
    return _userRepository.saveAuthenticationMethod(
        address,
        PasswordAuthentication(
          hashedPassword: sha256.convert(bytes).toString(),
        ));
  }
}
