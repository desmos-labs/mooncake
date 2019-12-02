import 'dart:async';
import 'dart:convert';

import 'package:desmosdemo/entities/entities.dart';
import 'package:desmosdemo/repositories/repositories.dart';
import 'package:desmosdemo/sources/sources.dart';
import 'package:meta/meta.dart';

/// Implementation of [PostsSource] that deals with local data.
class LocalPostsSource implements PostsSource {
  final FileStorage _postsStorage;
  final FileStorage _likesStorage;

  final _streamController = StreamController<Post>();

  LocalPostsSource({
    @required FileStorage postsStorage,
    @required FileStorage likesStorage,
  })  : assert(postsStorage != null),
        assert(likesStorage != null),
        _postsStorage = postsStorage,
        _likesStorage = likesStorage;

  String _getPostFileName(String postId) {
    return '$postId.json';
  }

  String get _likesFileName => 'likes.json';

  String get _unlikesFileName => 'unlikes.json';

  @override
  Stream<Post> get postsStream => _streamController.stream;

  @override
  Future<Post> getPostById(String postId) async {
    final fileName = _getPostFileName(postId);
    if (await _postsStorage.exits(fileName)) {
      final contents = await _postsStorage.read(fileName);
      return Post.fromJson(jsonDecode(contents));
    } else {
      return null;
    }
  }

  @override
  Future<List<Post>> getPosts() async {
    final files = await _postsStorage.listFiles();
    final strings = await Future.wait(files.map((file) => file.readAsString()));
    return strings
        .where((data) => data.isNotEmpty)
        .map((s) => Post.fromJson(jsonDecode(s)))
        .toList();
  }

  @override
  Future<void> savePost(Post post) async {
    // TODO: Check if the likes have been updated (add/remove new/old likes)

    // Check if there's a post with the same message and syncing, in
    // this case we need to replace the existing one
    final posts = await getPosts();
    final postToBeReplaced = posts.find(
      message: post.message,
      status: PostStatus.SYNCING,
    );

    // Save the post
    final fileName = _getPostFileName(postToBeReplaced?.id ?? post.id);
    await _postsStorage.write(fileName, jsonEncode(post.toJson()));

    // Emit the saved post
    _streamController.add(post);

    return post;
  }

  @override
  Future<void> savePosts(List<Post> posts) {
    return Future.wait(posts.map((post) => savePost(post)));
  }

  @override
  Future<void> deletePost(String postId) {
    final fileName = _getPostFileName(postId);
    return _postsStorage.delete(fileName);
  }

  // TODO: Do something with the methods below

  /// Returns all the ids of the posts that have been marked as to like.
  Future<List<String>> getPostsToLikeIds() async {
    final content = await _likesStorage.read(_likesFileName) ?? "[]";
    List<dynamic> postIds = jsonDecode(content);
    return postIds.map((entry) => entry.toString()).toList();
  }

  /// Returns all the ids of the posts that have been marked as to unlike.
  Future<List<String>> getPostsToUnlikeIds() async {
    final content = await _likesStorage.read(_unlikesFileName) ?? "[]";
    List<dynamic> postIds = jsonDecode(content);
    return postIds.map((entry) => entry.toString()).toList();
  }

  /// Marks the post with the given [postId] as a post to be liked.
  Future<void> likePost(String postId) async {
    final postIds = await getPostsToLikeIds();
    if (!postIds.contains(postId)) {
      final newIds = [postId] + postIds;
      await _likesStorage.write(_likesFileName, jsonEncode(newIds));
    }
  }

  /// Sets the post having the given [postId] as a post to be unliked.
  Future<void> unlikePost(String postId) async {
    final postIds = await getPostsToLikeIds();
    if (postIds.contains(postId)) {
      final newIds = postIds.where((id) => id != postId).toList();
      await _likesStorage.write(_likesFileName, jsonEncode(newIds));
    }
  }
}
