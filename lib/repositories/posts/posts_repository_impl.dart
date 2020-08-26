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
  final LocalSettingsSource _localSettingsSource;

  PostsRepositoryImpl({
    @required LocalPostsSource localSource,
    @required RemotePostsSource remoteSource,
    @required LocalSettingsSource localSettingsSource,
  })  : assert(localSource != null),
        _localPostsSource = localSource,
        assert(remoteSource != null),
        _remotePostsSource = remoteSource,
        assert(localSettingsSource != null),
        _localSettingsSource = localSettingsSource;

  @override
  Stream<List<Post>> getHomePostsStream(int limit) {
    return _localPostsSource.homePostsStream(limit);
  }

  @override
  Stream<dynamic> get homeEventsStream {
    return _remotePostsSource.homeEventsStream;
  }

  @override
  Future<List<Post>> getHomePosts({
    @required int start,
    @required int limit,
  }) async {
    final remotes = await _remotePostsSource.getHomePosts(
      start: start,
      limit: limit,
    );
    await _localPostsSource.savePosts(remotes, merge: true);
    return _localPostsSource.getHomePosts(start: start, limit: limit);
  }

  @override
  Stream<Post> getPostByIdStream(String postId) {
    return _localPostsSource.singlePostStream(postId);
  }

  @override
  Future<Post> getPostById(String postId, {bool refresh = false}) async {
    if (refresh) {
      final updated = await _remotePostsSource.getPostById(postId);
      if (updated != null) {
        await _localPostsSource.savePost(updated, merge: true);
      }
    }
    return _localPostsSource.getPostById(postId);
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

  /// Saves the given [posts] remotely and returns the proper status
  /// for each post based on the result of the operation.
  @visibleForTesting
  Future<PostStatus> savePostsRemotelyAndGetStatus(List<Post> posts) async {
    // Send the post transactions
    final result = await _remotePostsSource.savePosts(posts);

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
  }

  @override
  Future<void> syncPosts(String address) async {
    // Get the posts
    final posts = await _localPostsSource.getPostsToSync(address);
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
    final status = await savePostsRemotelyAndGetStatus(syncingPosts);
    final updatedPosts = syncingPosts.map((post) {
      return post.copyWith(status: status);
    }).toList();
    await _localPostsSource.savePosts(updatedPosts);

    // emit event that tx has been successfully added to the chain
    if (status.value == PostStatusValue.TX_SENT) {
      final currentTxAmount =
          await _localSettingsSource.get(SettingKeys.TX_AMOUNT) ?? 0;
      await _localSettingsSource.save(
          SettingKeys.TX_AMOUNT, currentTxAmount + updatedPosts.length);
    }
  }

  @override
  Future<void> deletePosts() {
    return _localPostsSource.deletePosts();
  }

  @override
  Future<void> deletePost(Post post) {
    return _localPostsSource.deletePost(post);
  }
}
