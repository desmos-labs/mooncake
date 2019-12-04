import 'dart:async';
import 'dart:convert';

import 'package:desmosdemo/entities/entities.dart';
import 'package:desmosdemo/repositories/repositories.dart';
import 'package:desmosdemo/sources/sources.dart';
import 'package:meta/meta.dart';

/// Implementation of [PostsSource] that deals with local data.
class LocalPostsSource implements PostsSource {
  final FileStorage _postsStorage;

  final _streamController = StreamController<Post>();

  LocalPostsSource({
    @required FileStorage postsStorage,
  })  : assert(postsStorage != null),
        _postsStorage = postsStorage;

  String _getPostFileName(String postId) {
    return '$postId.json';
  }

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
    // Check if there's a post with the same message and syncing, in
    // this case we need to replace the existing one
    final posts = await getPosts();
    final postToBeReplaced = posts.find(
      message: post.message,
      status: PostStatus.SYNCING,
    );

    // Remove the existing post
    if (postToBeReplaced != null) {
      final replacedFile = _getPostFileName(postToBeReplaced.id);
      await _postsStorage.delete(replacedFile);
    }

    // Save the post
    final fileName = _getPostFileName(post.id);
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
}
