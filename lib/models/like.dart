import 'package:equatable/equatable.dart';

/// Represents a like for a post that has been inserted by a specific user.
class Like extends Equatable {
  final String owner;

  Like(this.owner) : assert(owner != null);

  @override
  List<Object> get props {
    return [this.owner];
  }
}
