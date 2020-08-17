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
  final String reaction;

  AddOrRemovePostReaction(this.post, this.reaction);

  @override
  List<Object> get props => [post, reaction];

  @override
  String toString() => 'AddOrRemovePostReaction';
}

/// Tells the Bloc that the user has voted on poll contained inside the given
/// post with the given option.
class VotePoll extends PostsListEvent {
  final Post post;
  final PollOption option;

  VotePoll(this.post, this.option);

  @override
  List<Object> get props => [post, option];

  @override
  String toString() => 'VotePoll { post: $post, option: $option }';
}

/// Tells the Bloc that the specified post should be hidden from the user view.
class HidePost extends PostsListEvent {
  final Post post;

  HidePost(this.post);

  @override
  List<Object> get props => [post];

  @override
  String toString() => 'HidePost { post: $post }';
}

/// Tells the Bloc that the given [user] should be blocked.
class BlockUser extends PostsListEvent {
  final User user;

  BlockUser(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'ReportUser { user: $user }';
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

/// Tells the Bloc that more posts should be fetched and shown to the user.
class FetchPosts extends PostsListEvent {
  @override
  String toString() => 'FetchPosts';
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

/// Event that tells the Bloc to download all the posts stored locally.
/// WARNING: Use it ONLY during debug.
class DeletePosts extends PostsListEvent {}

/// Event that is emmited when a post is trying to upload again after a failed attempt
class RetryPostUpload extends PostsListEvent {
  final Post post;

  const RetryPostUpload(this.post);

  @override
  List<Object> get props => [post];
}

/// Event that tells the Bloc to delete a single post that is only stored locally
class DeletePost extends PostsListEvent {
  final Post post;

  const DeletePost(this.post);

  @override
  List<Object> get props => [post];
}
