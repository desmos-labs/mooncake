import 'package:dwitter/entities/entities.dart';

abstract class RemotePostsSource {
  /// Returns the post having the given [id].
  /// If no post with the given id was found, returns `null` instead.
  Future<Post> getPostById(String postId);

  /// Returns the list of all posts that represent comments to
  /// the post having the given [postId].
  Future<List<Post>> getPostComments(String postId);

  /// Starts sync new posts from the chain.
  Future<void> startSyncPosts();

  /// Returns a stream that emits new posts as soon as they
  /// are stored into the source.
  Stream<Post> get postsStream;

  /// Saves the given list of [posts] into the source.
  Future<void> savePosts(List<Post> posts);

  /// Deleted the post having the given [postId].
  Future<void> deletePost(String postId);
}
