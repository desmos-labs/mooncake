import 'dart:async';

import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/sources/sources.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Implementation of [PostsRepository].
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
    // Initialize the events update
    _remotePostsSource
        .getEventsStream()
        .asyncMap((event) {
          if (event is PostCreatedEvent) {
            return _mapPostCreatedEventToPosts(event);
          } else if (event is PostEvent) {
            return _mapPostEventToPosts(event);
          } else {
            return [];
          }
        })
        .expand((posts) => posts as List<Post>)
        .where((p) => p.subspace == Constants.SUBSPACE)
        .listen((post) async {
          _localPostsSource.savePost(post, emit: true);
        });
  }

  /// Transforms the given [event] to the list of posts to be updated.
  Future<List<Post>> _mapPostCreatedEventToPosts(PostCreatedEvent event) async {
    final posts = List<Post>();
    final post = await _remotePostsSource.getPostById(event.postId);

    if (post != null) {
      posts.add(post);
    }

    // Emit the updated parent
    if (post?.hasParent == true) {
      final parent = await _remotePostsSource.getPostById(post.parentId);
      if (parent != null) {
        posts.add(parent);
      }
    }

    return posts;
  }

  /// Maps the given [event] to the list of posts that should be updated.
  Future<List<Post>> _mapPostEventToPosts(PostEvent event) async {
    final posts = List<Post>();

    final post = await _remotePostsSource.getPostById(event.postId);
    if (post != null) {
      posts.add(post);
    }

    return posts;
  }

  @override
  Future<Post> getPostById(String postId) =>
      _localPostsSource.getPostById(postId);

  @override
  Future<List<Post>> getPostComments(String postId) async {
    final comments = await _remotePostsSource.getPostComments(postId);
    comments.forEach((comment) async {
      await _localPostsSource.savePost(comment, emit: false);
    });

    return _localPostsSource.getPostComments(postId);
  }

  @override
  Future<List<Post>> getPosts({bool forceOnline = false}) async {
    if (forceOnline) {
      final posts = await _remotePostsSource.getPosts();
      await _localPostsSource.savePosts(posts, emit: false);
    }

    return _localPostsSource.getPosts();
  }

  @override
  Future<List<Post>> getPostsToSync() => _localPostsSource.getPostsToSync();

  @override
  Stream<Post> get postsStream => _localPostsSource.postsStream;

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
  Future<void> syncPosts(List<Post> posts) =>
      _remotePostsSource.savePosts(posts);

  @override
  Future<void> deletePost(String postId) =>
      _localPostsSource.deletePost(postId);
}
