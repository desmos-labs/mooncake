import 'package:desmosdemo/models/models.dart';
import 'package:equatable/equatable.dart';

/// State related to the comments of a particular post.
abstract class PostCommentsState extends Equatable {
  const PostCommentsState();

  @override
  List<Object> get props => [];
}

/// Indicates that the comments are being loaded from the repository.
class PostCommentsLoading extends PostCommentsState {
  @override
  String toString() => 'PostCommentsLoading {}';
}

/// Tells that the comments have been properly loaded from the repository.
class PostCommentsLoaded extends PostCommentsState {
  final List<Post> comments;

  PostCommentsLoaded(this.comments);

  @override
  List<Object> get props => [comments];

  @override
  String toString() => 'PostCommentsLoaded { comments: $comments }';
}

/// Indicates that while loading the comments of a post, an error
/// has been returned.
class PostCommentsError extends PostCommentsState {
  final String message;

  PostCommentsError(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'PostCommentsError { message: $message }';
}