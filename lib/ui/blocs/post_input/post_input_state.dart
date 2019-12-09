import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

/// Represents the current state of a [CommentForm] while the user
/// is creating a new comment for a post.
@immutable
class PostInputState extends Equatable {
  final String message;
  final bool saving;

  PostInputState({
    @required this.message,
    @required this.saving,
  });

  bool get isValid => message != null && message.isNotEmpty;

  /// Builds an empty state.
  factory PostInputState.empty() => PostInputState(
        message: null,
        saving: false,
      );

  /// Updates this state setting the specified values properly.
  PostInputState update({String message, bool saving}) {
    return PostInputState(
      message: message ?? this.message,
      saving: saving ?? this.saving,
    );
  }

  @override
  List<Object> get props => [message, saving];

  @override
  String toString() {
    return 'CommentInputState {'
        'message: $message ,'
        'saving: $saving'
        '}';
  }
}
