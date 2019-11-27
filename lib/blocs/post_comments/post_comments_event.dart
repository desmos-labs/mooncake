import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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

/// Event that is emitted when a user wants to create a new
/// comment for a specific post.
class CreatePostComment extends PostCommentsEvent {
  final String postId;
  final String message;

  CreatePostComment({@required this.postId, @required this.message});

  @override
  List<Object> get props => [postId, message];

  @override
  String toString() => 'CreatePostComment { postId: $postId, message: $message }';
}