import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

/// Represents a generic event connected to a single like button.
abstract class PostLikeButtonEvent extends Equatable {
  const PostLikeButtonEvent();
}

/// Tells the BLoC that the initial data related to a single
/// like button has been loaded.
class PostLikeDataLoaded extends PostLikeButtonEvent {
  final bool isLiked;
  final int likesCount;

  PostLikeDataLoaded({@required this.isLiked, @required this.likesCount});

  @override
  List<Object> get props => [isLiked, likesCount];
}

/// Tells the BLoC that the button state has changed to be (un)selected.
class PostLikeButtonSelectedStateChanged extends PostLikeButtonEvent {
  final bool selected;

  PostLikeButtonSelectedStateChanged(this.selected);

  @override
  List<Object> get props => [selected];
}

/// Tells the BLoC that the like button has been clicked.
class PostLikeButtonClicked extends PostLikeButtonEvent {
  @override
  List<Object> get props => [];
}
