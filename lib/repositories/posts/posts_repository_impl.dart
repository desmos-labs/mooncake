import 'dart:async';

import 'package:dwitter/entities/entities.dart';
import 'package:dwitter/repositories/repositories.dart';
import 'package:dwitter/usecases/usecases.dart';
import 'package:flutter/cupertino.dart';

/// Implementation of [PostsRepository].
class PostsRepositoryImpl extends PostsRepository {
  final PostsSource _localPostsSource;
  final PostsSource _remotePostsSource;

  // ignore: cancel_subscriptions
  StreamSubscription _postsSubscription;

  PostsRepositoryImpl({
    @required PostsSource localSource,
    @required PostsSource remoteSource,
  })  : assert(localSource != null),
        _localPostsSource = localSource,
        assert(remoteSource != null),
        _remotePostsSource = remoteSource;

  @override
  Future<Post> getPostById(String postId) {
    return _localPostsSource.getPostById(postId);
  }

  @override
  Future<List<Post>> getPostComments(String postId) {
    return _localPostsSource.getPostComments(postId);
  }

  @override
  Future<List<Post>> getPosts() async {
    return _localPostsSource.getPosts();
  }

  @override
  Stream<Post> get postsStream {
    if (_postsSubscription == null) {
      _postsSubscription = _remotePostsSource.postsStream.listen((post) async {
        await _localPostsSource.savePost(post);
      });
    }
    return _localPostsSource.postsStream;
  }

  @override
  Future<void> savePost(Post post) async {
    // Save the post
    await _localPostsSource.savePost(post);

    // Update the parent comments if the parent exists and does not contain
    // the post id as a comment yet
    Post parent = await _localPostsSource.getPostById(post.parentId);
    if (parent != null && !parent.commentsIds.contains(post.id)) {
      parent = parent.copyWith(commentsIds: [post.id] + parent.commentsIds);
      await _localPostsSource.savePost(parent);
    }
  }

  @override
  Future<void> syncPosts(List<Post> posts) {
    return _remotePostsSource.savePosts(posts);
  }

  @override
  Future<void> deletePost(String postId) {
    return _localPostsSource.deletePost(postId);
  }
}
