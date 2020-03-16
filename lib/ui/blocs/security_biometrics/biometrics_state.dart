import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents a the state of the biometric setting screen.
class BiometricsState extends Equatable {
  /// Tells whether or not the authentication method is being saved.
  final bool saving;

  BiometricsState({@required this.saving});

  factory BiometricsState.initial() {
    return BiometricsState(
      saving: false,
    );
  }

  BiometricsState copyWith({
    bool saving,
  }) {
    return BiometricsState(
      saving: saving ?? this.saving,
    );
  }

  @override
  List<Object> get props => [saving];
}
