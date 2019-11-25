import 'package:equatable/equatable.dart';

/// Represents a generic event that is related to the comments
/// of a particular post.
abstract class PostCommentsEvent extends Equatable {
  const PostCommentsEvent();

  @override
  List<Object> get props => [];
}

/// Event that is emitted when there's the necessity of
/// loading the comments of a post having a specific id.
class LoadPostComments extends PostCommentsEvent {
  final String postId;

  LoadPostComments(this.postId);

  @override
  List<Object> get props => [postId];

  @override
  String toString() => 'LoadPostComments { postId: $postId }';
}