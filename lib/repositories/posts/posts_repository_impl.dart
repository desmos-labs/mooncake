import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
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
        _remotePostsSource = remoteSource;

  @override
  Stream<List<Post>> getHomePostsStream(int limit) {
    return _localPostsSource.homePostsStream(limit);
  }

  @override
  Stream<dynamic> get homeEventsStream {
    return _remotePostsSource.homeEventsStream;
  }

  @override
  Future<void> refreshHomePosts(int limit) async {
    final remotes = await _remotePostsSource.getHomePosts(limit);
    await _localPostsSource.savePosts(remotes, merge: true);
  }

  @override
  Stream<Post> getPostByIdStream(String postId) {
    return _localPostsSource.singlePostStream(postId);
  }

  @override
  Future<Post> getPostById(String postId, {bool refresh = false}) async {
    if (refresh) {
      final updated = await _remotePostsSource.getPostById(postId);
      await _localPostsSource.savePost(updated);
    }

    return _localPostsSource.getSinglePost(postId);
  }

  @override
  Future<List<Post>> getPostsByTxHash(String txHash) {
    return _localPostsSource.getPostsByTxHash(txHash);
  }

  @override
  Stream<List<Post>> getPostCommentsStream(String postId) {
    return _localPostsSource.getPostCommentsStream(postId);
  }

  @override
  Future<List<Post>> getPostComments(
    String postId, {
    bool refresh = false,
  }) async {
    if (refresh) {
      final updated = await _remotePostsSource.getPostComments(postId);
      await _localPostsSource.savePosts(updated);
    }

    return _localPostsSource.getPostComments(postId);
  }

  @override
  Future<void> savePost(Post post) {
    return _localPostsSource.savePost(post);
  }

  @override
  Future<void> savePosts(List<Post> posts) {
    return _localPostsSource.savePosts(posts);
  }

  @override
  Future<void> syncPosts() async {
    // Get the posts
    final posts = await _localPostsSource.getPostsToSync();
    if (posts.isEmpty) {
      // We do not have any post to be synced, so return.
      return;
    }

    // Set the posts as syncing
    final syncingStatus = PostStatus(value: PostStatusValue.SENDING_TX);
    final syncingPosts = posts.map((post) {
      return post.copyWith(status: syncingStatus);
    }).toList();
    await _localPostsSource.savePosts(syncingPosts);

    // Sync the posts and update the status based on the result
    final status = await savePostsAndGetStatus(syncingPosts);
    final updatedPosts = syncingPosts.map((post) {
      return post.copyWith(status: status);
    }).toList();
    await _localPostsSource.savePosts(updatedPosts);
  }

  @visibleForTesting
  Future<PostStatus> savePostsAndGetStatus(List<Post> syncingPosts) async {
    try {
      // Send the post transactions
      final result = await _remotePostsSource.savePosts(syncingPosts);

      // Update the posts based on the sync result
      PostStatus postStatus;
      switch (result.success) {
        case true:
          postStatus = PostStatus(
            value: PostStatusValue.TX_SENT,
            data: result.hash,
          );
          break;
        case false:
          postStatus = PostStatus(
            value: PostStatusValue.ERRORED,
            data: result.error.errorMessage,
          );
          break;
      }

      return postStatus;
    } catch (error) {
      return PostStatus(
        value: PostStatusValue.ERRORED,
        data: error.toString(),
      );
    }
  }
}
