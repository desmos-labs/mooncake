import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

/// Represents a generic post-related event.
abstract class PostsListEvent extends Equatable {
  const PostsListEvent();

  @override
  List<Object> get props => [];
}

/// Event that is emitted when the posts list has been updated.
class PostsUpdated extends PostsListEvent {
  final List<Post> posts;

  const PostsUpdated(this.posts);

  @override
  List<Object> get props => [posts];

  @override
  String toString() => 'PostsUpdated { posts: ${posts.length} }';
}

/// Tells the Bloc that it needs to either set as liked/unliked the given post.
class AddOrRemoveLike extends PostsListEvent {
  final Post post;

  AddOrRemoveLike(this.post);

  @override
  List<Object> get props => [post];
}

/// Tells the Bloc that it needs to either add (if not existing yet) or remove
/// (if existing) a reaction from the current user to the post.
class AddOrRemovePostReaction extends PostsListEvent {
  final Post post;
  final String reactionCode;

  AddOrRemovePostReaction(this.post, this.reactionCode);

  @override
  List<Object> get props => [post, reactionCode];

  @override
  String toString() => 'AddOrRemovePostReaction';
}

/// Tells the Bloc to inform the user that he should refresh the
/// home list of the posts.
class ShouldRefreshPosts extends PostsListEvent {
  @override
  String toString() => 'ShouldRefreshPosts';
}

/// Tells the Bloc that the currently shown list of posts should be refreshed.
class RefreshPosts extends PostsListEvent {
  @override
  String toString() => 'RefreshPosts';
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

/// Tells the Bloc that a transaction has been successful.
class TxSuccessful extends PostsListEvent {
  final String txHash;

  TxSuccessful({@required this.txHash}) : assert(txHash != null);

  @override
  List<Object> get props => [txHash];
}

/// Tells the Bloc that a transaction has failed with a given errror.
class TxFailed extends PostsListEvent {
  final String txHash;
  final String error;

  TxFailed({
    @required this.txHash,
    @required this.error,
  })  : assert(txHash != null),
        assert(error != null);

  @override
  List<Object> get props => [txHash, error];
}
