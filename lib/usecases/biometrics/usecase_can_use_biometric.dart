import 'package:local_auth/local_auth.dart';

/// Tells whether this device allows for biometrics authentication or not.
class CanUseBiometricsUseCase {
  /// Returns true if device is capable of checking biometrics
  Future<bool> check() {
    final auth = LocalAuthentication();
    return auth.canCheckBiometrics;
  }
}
