import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

/// Represents the state of the like button.
class PostLikeButtonState extends Equatable {
  /// Tells whether or not the post is liked from the current user.
  final bool isLiked;

  /// Tells the number of likes the post has.
  final int likesCount;

  /// Tells whether or not the button is currently selected.
  final bool isSelected;

  const PostLikeButtonState({
    @required this.isLiked,
    @required this.likesCount,
    @required this.isSelected,
  });

  @override
  List<Object> get props => [isLiked, isSelected];

  factory PostLikeButtonState.initial() {
    return PostLikeButtonState(
      isLiked: false,
      likesCount: 0,
      isSelected: false,
    );
  }

  PostLikeButtonState copyWith({
    bool isLiked,
    int likesCount,
    bool isSelected,
  }) {
    return PostLikeButtonState(
      isLiked: isLiked ?? this.isLiked,
      likesCount: likesCount ?? this.likesCount,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
