import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

/// Represents the current state of a [CommentForm] while the user
/// is creating a new comment for a post.
@immutable
class CommentInputState extends Equatable {
  final bool isMessageValid;

  CommentInputState({
    @required this.isMessageValid,
  });

  /// Builds an empty state.
  factory CommentInputState.empty() => CommentInputState(
        isMessageValid: false,
      );

  /// Builds a success state telling that the comment
  /// has been properly created.
  factory CommentInputState.success() => CommentInputState(
        isMessageValid: true,
      );

  /// Updates this state setting the specified values properly.
  CommentInputState update({
    bool isMessageValid,
  }) {
    return copyWith(
      isMessageValid: isMessageValid,
    );
  }

  /// Copies this state with the given data.
  CommentInputState copyWith({
    isMessageValid: bool,
  }) {
    return CommentInputState(
      isMessageValid: isMessageValid ?? this.isMessageValid,
    );
  }

  @override
  List<Object> get props => [isMessageValid];

  @override
  String toString() {
    return 'CommentInputState'
        'isMessageValid: $isMessageValid '
        '}';
  }
}
