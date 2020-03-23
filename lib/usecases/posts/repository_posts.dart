import 'package:mooncake/entities/entities.dart';

/// Represents the repository that can be used in order to read
/// and write data related to posts, comments and likes.
abstract class PostsRepository {
  /// Represents the steam of posts that emits all the new posts as
  /// well as the ones that need to be updated.
  Stream<List<Post>> get postsStream;

  /// Returns a [Stream] that subscribes to the post having the specified
  /// [postId], emitting the new data each time the post is updated.
  Stream<Post> getPostByIdStream(String postId);

  /// Returns the post having the given [postId] currently stored.
  Future<Post> getPostById(String postId);

  /// Returns a list of all the posts that have been included inside
  /// the transaction having the given [txHash].
  Future<List<Post>> getPostsByTxHash(String txHash);

  /// Returns a [Stream] that emits all the comments of the post
  /// having the given [postId] as soon as they are created or updated.
  Stream<List<Post>> getPostComments(String postId);

  /// Saves the given post inside the repository
  Future<void> savePost(Post post);

  /// Syncs all the posts that are currently awaiting to be synced.
  Future<void> syncPosts();
}
