import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object> get props => [];
}

/// Tells the Bloc that it needs to load posts from the [PostsRepository].
class LoadPosts extends PostsEvent {}

/// Tells the Bloc that it needs to add a new post to the list of posts
class AddPost extends PostsEvent {
  final String message;
  final String parentId;

  AddPost({
    @required this.message,
    this.parentId,
  });

  @override
  List<Object> get props => [message, parentId];

  @override
  String toString() => 'AddPost { message: $message, parentId: $parentId }';
}

/// Tells the Bloc that it needs to set a post as liked.
class LikePost extends PostsEvent {
  final String postId;

  LikePost(this.postId);

  @override
  List<Object> get props => [postId];

  @override
  String toString() => 'LikePost { postId: $postId }';
}

/// Tells the Bloc that it needs to set the given post as unliked
class UnlikePost extends PostsEvent {
  final String postId;

  UnlikePost(this.postId);

  @override
  List<Object> get props => [postId];

  @override
  String toString() => 'UnlikePost { postId: $postId }';
}

class SyncPosts extends PostsEvent {}

class SyncPostsCompleted extends PostsEvent {}
