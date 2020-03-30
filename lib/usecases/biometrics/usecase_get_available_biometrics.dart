import 'package:local_auth/local_auth.dart';

/// Allows to easily get the list of biometric authentication types
/// that the current device supports.
class GetAvailableBiometricsUseCase {
  /// Returns a list of enrolled biometrics
  ///
  /// Returns a [Future] List<BiometricType> with the following possibilities:
  /// - BiometricType.face
  /// - BiometricType.fingerprint
  /// - BiometricType.iris (not yet implemented)
  Future<List<BiometricType>> check() {
    final auth = LocalAuthentication();
    return auth.getAvailableBiometrics();
  }
}
