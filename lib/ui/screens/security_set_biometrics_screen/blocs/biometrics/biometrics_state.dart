import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:local_auth/local_auth.dart';

/// Represents a the state of the biometric setting screen.
class BiometricsState extends Equatable {
  /// Tells whether or not the authentication method is being saved.
  final bool saving;

  /// Tells what biometric authentication type the device supports.
  final BiometricType availableBiometric;

  BiometricsState({
    @required this.saving,
    @required this.availableBiometric,
  });

  factory BiometricsState.initial() {
    return BiometricsState(
      saving: false,
      availableBiometric: BiometricType.fingerprint,
    );
  }

  BiometricsState copyWith({
    bool saving,
    BiometricType availableBiometric,
  }) {
    return BiometricsState(
      saving: saving ?? this.saving,
      availableBiometric: availableBiometric ?? this.availableBiometric,
    );
  }

  @override
  List<Object> get props {
    return [saving, availableBiometric];
  }

  @override
  String toString() {
    return 'BiometricsState { '
        'saving: $saving, '
        'availableBiometric: $availableBiometric '
        '}';
  }
}
