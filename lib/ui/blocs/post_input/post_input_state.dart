import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

/// Represents the current state of a [CommentForm] while the user
/// is creating a new comment for a post.
@immutable
class PostInputState extends Equatable {
  final String message;
  final bool allowsComments;
  final bool saving;

  PostInputState({
    @required this.message,
    @required this.allowsComments,
    @required this.saving,
  });

  bool get isValid => message != null && message.isNotEmpty;

  /// Builds an empty state.
  factory PostInputState.empty() => PostInputState(
        message: null,
        allowsComments: true,
        saving: false,
      );

  /// Updates this state setting the specified values properly.
  PostInputState update({String message, bool allowsComments, bool saving}) {
    return PostInputState(
      message: message ?? this.message,
      allowsComments: allowsComments ?? this.allowsComments,
      saving: saving ?? this.saving,
    );
  }

  @override
  List<Object> get props => [message, saving, allowsComments];

  @override
  String toString() {
    return 'CommentInputState {'
        'message: $message ,'
        'allowsComments: $allowsComments, '
        'saving: $saving'
        '}';
  }
}
