import 'package:equatable/equatable.dart';
import 'package:mooncake/entities/entities.dart';

/// Represents a generic post-related event.
abstract class PostsListEvent extends Equatable {
  const PostsListEvent();

  @override
  List<Object> get props => [];
}

/// Event that is emitted when the user using the application
/// has been updated for some reason.
class UserUpdated extends PostsListEvent {
  final MooncakeAccount user;

  UserUpdated(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'UserUpdated { user: $user }';
}

/// Event that is emitted when the posts list has been updated.
class PostsUpdated extends PostsListEvent {
  final List<Post> posts;

  const PostsUpdated(this.posts);

  @override
  List<Object> get props => [posts];

  @override
  String toString() => 'ShowPosts { posts: ${posts.length} }';
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
