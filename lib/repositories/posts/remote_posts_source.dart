import 'dart:async';

import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/sources/posts/export.dart';

/// Represents the remote source that needs to be called when wanting to
/// download data from the server.
abstract class RemotePostsSource {
  /// Represents the steam of posts that emits all the new posts as
  /// well as the ones that need to be updated.
  Stream<List<Post>> get postsStream;

  /// Returns a [Stream] that subscribes to the post having the specified
  /// [postId], emitting the new data each time the post is updated.
  Stream<Post> getPostById(String postId);

  /// Saves the given list of [posts] into the source.
  Future<void> savePosts(List<Post> posts);
}
