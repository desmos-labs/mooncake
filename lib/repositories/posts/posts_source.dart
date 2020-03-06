import 'package:mooncake/entities/entities.dart';

/// Represents the source that should be used when dealing with posts.
abstract class LocalPostsSource {
  /// Returns a stream that emits new posts as soon as they
  /// are stored into the source.
  Stream<List<Post>> get postsStream;

  /// Returns the post having the given [id].
  /// If no post with the given id was found, returns `null` instead.
  Stream<Post> getPostById(String postId);

  /// Returns the list of all posts that represent comments to
  /// the post having the given [postId].
  Stream<List<Post>> getPostComments(String postId);

  /// Returns the list of all the currently stored posts.
  Future<List<Post>> getPosts();

  /// Returns the list of all the posts to be synced.
  Future<List<Post>> getPostsToSync();

  /// Saves the given [post] inside the source.
  /// Upon having stored it properly, it emits the new set of posts
  /// to the [postsStream].
  Future<void> savePost(Post post);
}
