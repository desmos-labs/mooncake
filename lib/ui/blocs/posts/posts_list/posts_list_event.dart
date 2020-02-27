import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

/// Represents a generic post-related event.
abstract class PostsListEvent extends Equatable {
  const PostsListEvent();

  @override
  List<Object> get props => [];
}

/// Tells the Bloc that it needs to load posts from the [PostsRepository].
class LoadPosts extends PostsListEvent {
  @override
  String toString() => 'LoadPosts';
}

class RefreshPosts extends PostsListEvent {
  @override
  String toString() => 'RefreshPosts';
}

/// Tells the Bloc that it needs to add a new post to the list of posts
class AddPost extends PostsListEvent {
  final Post post;

  AddPost(this.post);

  @override
  List<Object> get props => [post];

  @override
  String toString() => 'AddPost { post: $post }';
}



/// Tells the bloc to start the synchronization of locally stored
/// posts so that they can be uploaded to the chain.
class SyncPosts extends PostsListEvent {
  @override
  String toString() => 'SyncPosts';
}

/// Tells the bloc that the synchronization of the locally stored posts
/// have been completed.
class SyncPostsCompleted extends PostsListEvent {
  @override
  String toString() => 'SyncPostsCompleted';
}
