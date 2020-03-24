import 'dart:async';

import 'package:mooncake/entities/entities.dart';

/// Represents the remote source that needs to be called when wanting to
/// download data from the server.
abstract class RemotePostsSource {
  /// Returns the posts that should be seen inside the home page.
  Future<List<Post>> getHomePosts(int limit);

  /// [Stream] that emits an item each time that the home posts
  /// list should be updated.
  Stream<dynamic> get homeEventsStream;

  /// Returns the post having the given [id].
  /// If no post with the given id was found, returns `null` instead.
  Future<Post> getPostById(String postId);

  /// Saves the given list of [posts] into the source.
  Future<TransactionResult> savePosts(List<Post> posts);
}
