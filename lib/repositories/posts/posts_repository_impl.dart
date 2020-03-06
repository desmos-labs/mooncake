import 'dart:async';

import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/sources/sources.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Implementation of [PostsRepository] that listens for remote
/// changes, persists them locally and then emits the locally-stored
/// data once they have been saved properly.
/// This is to have a single source of through (the local data) instead
/// of multiple once.
class PostsRepositoryImpl extends PostsRepository {
  final LocalPostsSource _localPostsSource;
  final RemotePostsSource _remotePostsSource;

  PostsRepositoryImpl({
    @required LocalPostsSource localSource,
    @required RemotePostsSource remoteSource,
  })  : assert(localSource != null),
        _localPostsSource = localSource,
        assert(remoteSource != null),
        _remotePostsSource = remoteSource {
    // Start listening for remote changes and store them locally
    _remotePostsSource.postsStream.expand((list) => list).listen((post) async {
      _localPostsSource.savePost(post);
    });
  }

  @override
  Stream<List<Post>> get postsStream => _localPostsSource.postsStream;

  @override
  Stream<Post> getPostById(String postId) =>
      _localPostsSource.getPostById(postId);

  @override
  Stream<List<Post>> getPostComments(String postId) =>
      _localPostsSource.getPostComments(postId);

  @override
  Future<void> savePost(Post post) => _localPostsSource.savePost(post);

  @override
  Future<void> syncPosts() async {
    // Get the posts
    final posts = await _localPostsSource.getPostsToSync();
    final syncingStatus = PostStatus(value: PostStatusValue.SYNCING);
    final syncingPosts =
        posts.map((post) => post.copyWith(status: syncingStatus)).toList();

    if (syncingPosts.isEmpty) {
      // We do not have any post to be synced, so return.
      return;
    }

    // Set the posts as syncing
    syncingPosts.forEach((post) async {
      await _localPostsSource.savePost(post);
    });

    // Send the post transactions
    try {
      await _remotePostsSource.savePosts(syncingPosts);
    } catch (error) {
      print("Sync error: $error");
      final status = PostStatus(
        value: PostStatusValue.ERRORED,
        error: error.toString(),
      );

      // Set the posts state to failed
      syncingPosts.forEach((post) async {
        await _localPostsSource.savePost(post.copyWith(status: status));
      });
    }
  }
}
