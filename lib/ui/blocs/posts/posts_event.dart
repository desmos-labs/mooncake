import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

/// Represents a generic post-related event.
abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object> get props => [];
}

/// Tells the Bloc that it needs to load posts from the [PostsRepository].
class LoadPosts extends PostsEvent {
  @override
  String toString() => 'LoadPosts';
}

class RefreshPosts extends PostsEvent {
  @override
  String toString() => 'RefreshPosts';
}

/// Tells the Bloc that it needs to add a new post to the list of posts
class AddPost extends PostsEvent {
  final Post post;

  AddPost(this.post);

  @override
  List<Object> get props => [post];

  @override
  String toString() => 'AddPost { post: $post }';
}

/// Tells the Bloc that it needs to either add (if not existing yet) or remove
/// (if existing) a reaction from a user.
class AddOrRemovePostReaction extends PostsEvent {
  final String postId;
  final String reaction;

  AddOrRemovePostReaction({@required this.postId, @required this.reaction});

  @override
  List<Object> get props => [postId, reaction];

  @override
  String toString() => 'AddOrRemovePostReaction { '
      'postId: $postId, '
      'reaction: $reaction '
      '}';
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
