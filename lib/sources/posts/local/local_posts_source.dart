import 'dart:async';
import 'dart:convert';

import 'package:desmosdemo/entities/entities.dart';
import 'package:desmosdemo/repositories/repositories.dart';
import 'package:desmosdemo/sources/sources.dart';
import 'package:meta/meta.dart';

/// Implementation of [PostsSource] that deals with local data.
class LocalPostsSource implements PostsSource {
  final WalletSource _walletSource;
  final FileStorage _postsStorage;

  final _streamController = StreamController<Post>();

  LocalPostsSource({
    @required FileStorage postsStorage,
    @required WalletSource walletSource,
  })  : assert(postsStorage != null),
        _postsStorage = postsStorage,
        assert(walletSource != null),
        _walletSource = walletSource;

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

    final syncingPost = posts.find(
      message: post.message,
      status: PostStatus.SYNCING,
    );
    if (syncingPost != null) {
      // Another post with the same message and another id was syncing.
      // This means that it was a locally created post that has now been sent
      // to the blockchain. In this case we need to delete the local one as it
      // is now obsolete.
      final replacedFile = _getPostFileName(syncingPost.id);
      await _postsStorage.delete(replacedFile);
    }

    final existingPost = posts.find(id: post.id);
    if (existingPost != null && post.status == PostStatus.SYNCED) {
      // The new post is coming directly from the chain, and
      // another post with the same id already exists locally. This means that
      // a new like/comment has been added or removed to the post itself from
      // the chain.
      // In this case we need to merge the likes/comments of the new post into
      // the ones of the old one preserving the state of the old one so that
      // if it was to be synced it will be synced next
      post = existingPost.updateWith(post);
    }

    // Update the liked field
    final address = await _walletSource.getAddress();
    post = post.copyWith(liked: post.containsLikeFromUser(address));

    // Save the post
    print('Saving post with id ${post.id}');
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
