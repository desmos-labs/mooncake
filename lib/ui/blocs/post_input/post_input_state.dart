import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

/// Represents the current state of a [CommentForm] while the user
/// is creating a new comment for a post.
@immutable
class PostInputState extends Equatable {
  final String message;
  final bool allowsComments;
  final List<File> medias;
  final bool saving;

  PostInputState({
    @required this.message,
    @required this.allowsComments,
    @required this.medias,
    @required this.saving,
  });

  bool get isValid =>
      (message != null && message.isNotEmpty) || medias.isNotEmpty;

  /// Builds an empty state.
  factory PostInputState.empty() => PostInputState(
        message: null,
        allowsComments: true,
        medias: [],
        saving: false,
      );

  /// Updates this state setting the specified values properly.
  PostInputState update({
    String message,
    bool allowsComments,
    List<File> medias,
    bool saving,
  }) {
    return PostInputState(
      message: message ?? this.message,
      allowsComments: allowsComments ?? this.allowsComments,
      saving: saving ?? this.saving,
      medias: medias ?? this.medias,
    );
  }

  @override
  List<Object> get props => [message, allowsComments, medias, saving];

  @override
  String toString() {
    return 'CommentInputState {'
        'message: $message ,'
        'allowsComments: $allowsComments, '
        'medias: $medias, '
        'saving: $saving'
        '}';
  }
}
