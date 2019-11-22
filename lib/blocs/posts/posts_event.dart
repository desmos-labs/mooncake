import 'package:desmosdemo/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object> get props => [];
}

/// Tells the Bloc that it needs to load posts from the [PostsRepository].
class LoadPosts extends PostsEvent {}

/// Tells the Bloc that it needs to add a new post to the list of posts
class AddPost extends PostsEvent {
  final Post post;

  const AddPost(this.post);

  @override
  List<Object> get props => [post];

  @override
  String toString() => 'AddPost { post: $post }';
}

/// Tells the Bloc that it needs to set a post as liked.
class LikePost extends PostsEvent {
  final Post post;

  const LikePost(this.post);

  @override
  List<Object> get props => [post];

  @override
  String toString() => 'LikePost { post: $post }';
}

/// Tells the Bloc that it needs to set the given post as unliked
class UnlikePost extends PostsEvent {
  final Post post;

  const UnlikePost(this.post);

  @override
  List<Object> get props => [post];

  @override
  String toString() => 'UnlikePost { post: $post }';
}
