import 'package:local_auth/local_auth.dart';
import 'package:meta/meta.dart';

/// Tells whether this device allows for biometrics authentication or not.
class CanUseBiometricsUseCase {
  final LocalAuthentication _localAuthentication;

  CanUseBiometricsUseCase({@required LocalAuthentication localAuthentication})
      : assert(localAuthentication != null),
        _localAuthentication = localAuthentication;

  /// Returns true if device is capable of checking biometrics
  Future<bool> check() {
    return _localAuthentication.canCheckBiometrics;
  }
}
