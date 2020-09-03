import 'package:local_auth/local_auth.dart';
import 'package:meta/meta.dart';

/// Allows to easily get the list of biometric authentication types
/// that the current device supports.
class GetAvailableBiometricsUseCase {
  final LocalAuthentication _localAuthentication;

  GetAvailableBiometricsUseCase({
    @required LocalAuthentication localAuthentication,
  })  : assert(localAuthentication != null),
        _localAuthentication = localAuthentication;

  /// Returns a list of enrolled biometrics
  ///
  /// Returns a [Future] List<BiometricType> with the following possibilities:
  /// - BiometricType.face
  /// - BiometricType.fingerprint
  /// - BiometricType.iris (not yet implemented)
  Future<List<BiometricType>> get() {
    return _localAuthentication.getAvailableBiometrics();
  }
}
