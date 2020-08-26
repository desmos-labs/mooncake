import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

/// Represents the repository that can be used in order to read
/// and write data related to posts, comments and likes.
abstract class PostsRepository {
  /// Returns the posts that should be seen inside the home page.
  Stream<List<Post>> getHomePostsStream(int limit);

  /// [Stream] that emits an item each time that the home posts
  /// list should be updated.
  Stream<dynamic> homeEventsStream;

  /// Refreshes the home posts downloading the ones present remotely and
  /// saving them locally.
  Future<List<Post>> getHomePosts({
    @required int start,
    @required int limit,
  });

  /// Returns a [Stream] that subscribes to the post having the specified
  /// [postId], emitting the new data each time the post is updated.
  Stream<Post> getPostByIdStream(String postId);

  /// Returns the post having the given [postId] currently stored.
  /// If [refresh] is `true`, first downloads the updated data from the
  /// remote server.
  Future<Post> getPostById(String postId, {bool refresh = false});

  /// Returns a list of all the posts that have been included inside
  /// the transaction having the given [txHash].
  Future<List<Post>> getPostsByTxHash(String txHash);

  /// Returns a [Stream] that emits all the comments of the post
  /// having the given [postId] as soon as they are created or updated.
  Stream<List<Post>> getPostCommentsStream(String postId);

  /// Returns a [Future] that emits all the comments of the post
  /// having the given [postId] stored locally. If [refresh] is true,
  /// the comments are firstly downloaded from the remote source.
  Future<List<Post>> getPostComments(String postId, {bool refresh = false});

  /// Saves the given post inside the repository.
  /// If emit is true, emits the new list of posts using the stream.
  Future<void> savePost(Post post);

  /// Saves the given post inside the repository.
  Future<void> savePosts(List<Post> posts);

  /// Syncs all the posts that are currently awaiting to be synced.
  Future<void> syncPosts(String address);

  /// Deletes the locally stored posts.
  Future<void> deletePosts();

  /// Deletes the locally stored post.
  Future<void> deletePost(Post post);
}
