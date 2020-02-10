import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents a generic event that has been emitted from the chain.
abstract class ChainEvent extends Equatable {
  /// Represents the block height at which the event was emitted;
  final String height;

  ChainEvent({@required this.height}) : assert(height != null);
}
