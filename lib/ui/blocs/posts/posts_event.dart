import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object> get props => [];
}

/// Tells the bloc to start fetching the posts that are present inside
/// the chain.
class FetchPosts extends PostsEvent {
  @override
  String toString() => 'FetchPosts';
}

/// Tells the bloc that the posts have been fetched from the chain.
class FetchPostsCompleted extends PostsEvent {
  @override
  String toString() => 'FetchPostsCompleted';
}

/// Tells the Bloc that it needs to load posts from the [PostsRepository].
class LoadPosts extends PostsEvent {
  LoadPosts();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'LoadPosts';
}

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

/// Tells the bloc to start the synchronization of locally stored
/// posts so that they can be uploaded to the chain.
class SyncPosts extends PostsEvent {
  @override
  String toString() => 'SyncPosts';
}

/// Tells the bloc that the synchronization of the locally stored posts
/// have been completed.
class SyncPostsCompleted extends PostsEvent {
  @override
  String toString() => 'SyncPostsCompleted';
}
