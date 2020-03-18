import 'dart:async';

import 'package:mooncake/entities/entities.dart';

/// Represents the remote source that needs to be called when wanting to
/// download data from the server.
abstract class RemotePostsSource {
  /// Represents the steam of posts that emits all the new posts as
  /// well as the ones that need to be updated.
  Stream<List<Post>> get postsStream;

  /// Saves the given list of [posts] into the source.
  Future<void> savePosts(List<Post> posts);
}
