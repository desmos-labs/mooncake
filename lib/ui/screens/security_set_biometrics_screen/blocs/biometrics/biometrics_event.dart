import 'package:equatable/equatable.dart';

/// Represents a generic event that is emitted regarding the biometric screen.
abstract class BiometricsEvent extends Equatable {
  const BiometricsEvent();

  @override
  List<Object> get props => [];
}

/// Tells the Bloc to check what type of biometric authentication the
/// device supports.
class CheckAuthenticationType extends BiometricsEvent {
  @override
  String toString() => 'CheckAuthenticationType';
}

/// Tells the Bloc that the user wants to be authenticated.
class AuthenticateWithBiometrics extends BiometricsEvent {
  @override
  String toString() => 'AuthenticateWithBiometrics';
}
