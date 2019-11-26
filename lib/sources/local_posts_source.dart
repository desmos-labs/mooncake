import 'dart:convert';

import 'package:desmosdemo/models/models.dart';
import 'package:desmosdemo/sources/sources.dart';
import 'package:meta/meta.dart';

import '../models/models.dart';

class LocalPostsSource {
  final FileStorage _fileStorage;

  LocalPostsSource({
    @required FileStorage fileStorage,
  })  : assert(fileStorage != null),
        _fileStorage = fileStorage;

  String _getPostCacheFileName(Post post) {
    return 'cache-${post.id}';
  }

  /// Saves the given [post] to be later uploaded to the blockchain.
  Future<void> cachePostForUpload(Post post) async {
    final fileName = _getPostCacheFileName(post);
    _fileStorage.write(fileName, jsonEncode(post.toJson()));
  }

  /// Removes the given [post] from the cache of the posts that still
  /// needs to be sent to the blockchain.
  /// If the post has already been sent to the chain, throws an
  /// [Exception].
  Future<void> deleteCachedPost(Post post) async {
    final fileName = _getPostCacheFileName(post);
    await _fileStorage.delete(fileName);
  }

  /// Finds the post having the same id as the [post] given, and edits
  /// its details to match the new one.
  /// If no post with the same id of the given one has been found,
  /// returns an error.
  Future<void> editPost(Post post) async {
    final cacheFileName = _getPostCacheFileName(post);
    if (await _fileStorage.exits(cacheFileName)) {
      return _fileStorage.write(cacheFileName, jsonEncode(post.toJson()));
    }

    // TODO: If not inside the cache, edit the remote one
  }

  /// Saves the given [posts] locally, so that they can be fetched
  /// faster for later reading.
  Future<List<Post>> savePosts(List<Post> posts) async {
    for (int index = 0; index < posts.length; index++) {
      final post = posts[index];
      await _fileStorage.write(post.id, jsonEncode(post.toJson()));
    }
    return posts + await getPosts();
  }

  /// Returns the full list of locally stored posts.
  Future<List<Post>> getPosts() async {
    final files = await _fileStorage.listFiles();
    final strings = await Future.wait(files.map((file) => file.readAsString()));
    return strings
        .where((data) => data.isNotEmpty)
        .map((s) => Post.fromJson(jsonDecode(s)))
        .toList();
  }

  /// Returns the post having the given [postId] or `null` if no such
  /// post was found.
  Future<Post> getPostById(String postId) async {
    final files = await _fileStorage.listFiles();
    final file = files.firstWhere(
      (file) => file.path.contains(postId),
      orElse: null,
    );
    if (file != null) {
      return Post.fromJson(jsonDecode(await file.readAsString()));
    }

    return null;
  }
}
