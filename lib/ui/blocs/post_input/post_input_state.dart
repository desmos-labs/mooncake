import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

/// Represents the current state of a [CommentForm] while the user
/// is creating a new comment for a post.
@immutable
class PostInputState extends Equatable {
  final String message;

  PostInputState({@required this.message});

  bool get isValid => message != null && message.isNotEmpty;

  /// Builds an empty state.
  factory PostInputState.empty() => PostInputState(
        message: null,
      );

  /// Updates this state setting the specified values properly.
  PostInputState update({
    String message,
  }) {
    return copyWith(
      message: message,
    );
  }

  /// Copies this state with the given data.
  PostInputState copyWith({
    message: String,
  }) {
    return PostInputState(
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [message];

  @override
  String toString() {
    return 'CommentInputState {'
        'message: $message '
        '}';
  }
}
