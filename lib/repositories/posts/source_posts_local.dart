import 'package:mooncake/entities/entities.dart';

/// Represents the source that should be used when dealing with posts.
abstract class LocalPostsSource {
  /// Returns a stream that emits new posts as soon as they
  /// are stored into the source.
  Stream<List<Post>> get postsStream;

  /// Returns the posts that should be seen inside the home page.
  Stream<List<Post>> homePostsStream(int limit);

  /// Returns the post having the given [id].
  /// If no post with the given id was found, returns `null` instead.
  Stream<Post> singlePostStream(String postId);

  /// Returns the list of home posts.
  Future<List<Post>> getHomePosts({int start = 0, int limit = 50});

  /// Returns the details of the post currently stored inside the device.
  Future<Post> getPostById(String postId);

  /// Returns the list of posts that have been included inside the
  /// transaction having the given [txHash].
  Future<List<Post>> getPostsByTxHash(String txHash);

  /// Returns the list of all posts that represent comments to
  /// the post having the given [postId].
  Stream<List<Post>> getPostCommentsStream(String postId);

  /// Returns the list of the comments to the post having
  /// the specified [postId].
  Future<List<Post>> getPostComments(String postId);

  /// Returns the list of all the posts to be synced that somehow interest
  /// the user having the given [address].
  /// This means that the returned posts will be all and only the ones
  /// that the user has either created or interacted with
  /// (reacted to, voted to, etc).
  Future<List<Post>> getPostsToSync(String address);

  /// Saves the given [post] inside the source.
  /// If [merge] is set to `true`, the contents of the existing post and the
  /// given [post] will be merged. Otherwise, the new contents will replace
  /// the existing ones.
  Future<void> savePost(Post post, {bool merge = false});

  /// Saves the given [posts] inside the source.
  /// Upon having stored them properly, it emits the new set of posts
  /// to the [postsStream].
  Future<void> savePosts(List<Post> posts, {bool merge = false});

  /// Deletes the locally stored posts.
  Future<void> deletePosts();

  /// Deletes a locally stored post.
  Future<void> deletePost(Post post);
}
