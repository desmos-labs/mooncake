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

  /// Returns the details of the post currently stored inside the device.
  Future<Post> getSinglePost(String postId);

  /// Returns the list of posts that have been included inside the
  /// transaction having the given [txHash].
  Future<List<Post>> getPostsByTxHash(String txHash);

  /// Returns the list of all posts that represent comments to
  /// the post having the given [postId].
  Stream<List<Post>> getPostComments(String postId);

  /// Returns the list of all the posts to be synced.
  Future<List<Post>> getPostsToSync();

  /// Saves the given [post] inside the source.
  /// If [emits] is `true`, emits the new set of posts using the [postsStream].
  Future<void> savePost(Post post, {bool emit = true});

  /// Saves the given [posts] inside the source.
  /// Upon having stored them properly, it emits the new set of posts
  /// to the [postsStream].
  Future<void> savePosts(List<Post> posts, {bool merge = false});
}
