import 'dart:async';

import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/sources/posts/export.dart';

abstract class RemotePostsSource {
  /// Returns the stream emitting all the chain events.
  Stream<ChainEvent> getEventsStream();

  /// Returns all the posts stored on the source.
  Future<List<Post>> getPosts();

  /// Returns the post having the given [id].
  /// If no post with the given id was found, returns `null` instead.
  Future<Post> getPostById(String postId);

  /// Returns the list of all posts that represent comments to
  /// the post having the given [postId].
  Future<List<Post>> getPostComments(String postId);

  /// Saves the given list of [posts] into the source.
  Future<void> savePosts(List<Post> posts);

  /// Deleted the post having the given [postId].
  Future<void> deletePost(String postId);
}
