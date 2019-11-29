import 'dart:convert';

import 'package:desmosdemo/models/models.dart';
import 'package:desmosdemo/sources/sources.dart';
import 'package:meta/meta.dart';

class LocalPostsSource {
  final FileStorage _postsStorage;
  final FileStorage _likesStorage;

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

  /// Saves the given [post], either creating a new entry, or
  /// replacing the existing contents if a post with the same id
  /// already exists.
  Future<void> savePost(Post post) async {
    final fileName = _getPostFileName(post.id);
    await _postsStorage.write(fileName, jsonEncode(post.toJson()));
  }

  /// Returns the post having the given [postId] or `null` if no such
  /// post was found.
  Future<Post> getPost(String postId) async {
    final fileName = _getPostFileName(postId);
    if (await _postsStorage.exits(fileName)) {
      final contents = await _postsStorage.read(fileName);
      return Post.fromJson(jsonDecode(contents));
    } else {
      return null;
    }
  }

  /// Removes the given [post] from the cache of the posts that still
  /// needs to be sent to the blockchain.
  /// If the post has already been sent to the chain, throws an
  /// [Exception].
  Future<void> deleteCachedPost(Post post) async {
    final foundPost = await getPost(post.id);
    if (!foundPost.synced) {
      await _postsStorage.delete(_getPostFileName(foundPost.id));
    } else {
      throw Exception("Cannot deleted an already synced post");
    }
  }

  /// Returns the full list of locally stored posts.
  Future<List<Post>> getPosts() async {
    final files = await _postsStorage.listFiles();
    final strings = await Future.wait(files.map((file) => file.readAsString()));
    return strings
        .where((data) => data.isNotEmpty)
        .map((s) => Post.fromJson(jsonDecode(s)))
        .toList();
  }

  String get _likesFileName => 'likes.json';
  String get _unlikesFileName => 'unlikes.json';

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
