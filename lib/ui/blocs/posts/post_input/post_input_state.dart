import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mooncake/entities/entities.dart';

/// Represents the current state of a [CommentForm] while the user
/// is creating a new comment for a post.
@immutable
class PostInputState extends Equatable {
  final Post parentPost;

  final String message;
  final List<PostMedia> medias;
  final bool allowsComments;

  final bool showPopup;
  final bool saving;
  final willShowPopupAgain;

  PostInputState({
    @required this.parentPost,
    @required this.message,
    @required this.allowsComments,
    @required this.medias,
    @required this.saving,
    @required this.showPopup,
    @required this.willShowPopupAgain,
  });

  bool get isValid => message != null && message.isNotEmpty;

  /// Builds an empty state.
  factory PostInputState.empty(Post parentPost) {
    return PostInputState(
      parentPost: parentPost,
      message: null,
      allowsComments: true,
      medias: [],
      saving: false,
      showPopup: false,
      willShowPopupAgain: true,
    );
  }

  /// Updates this state setting the specified values properly.
  PostInputState update({
    String message,
    bool allowsComments,
    List<PostMedia> medias,
    bool showPopup,
    bool saving,
    bool willShowPopupAgain,
  }) {
    return PostInputState(
      parentPost: parentPost,
      message: message ?? this.message,
      allowsComments: allowsComments ?? this.allowsComments,
      saving: saving ?? this.saving,
      medias: medias ?? this.medias,
      showPopup: showPopup ?? this.showPopup,
      willShowPopupAgain: willShowPopupAgain ?? this.willShowPopupAgain,
    );
  }

  @override
  List<Object> get props => [
        parentPost,
        message,
        allowsComments,
        medias,
        saving,
        showPopup,
        willShowPopupAgain,
      ];
}
