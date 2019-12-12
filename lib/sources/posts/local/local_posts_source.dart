import 'dart:async';

import 'package:dwitter/entities/entities.dart';
import 'package:dwitter/repositories/repositories.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';

import 'db_helper.dart';

/// Implementation of [LocalPostsSource] that deals with local data.
class LocalPostsSourceImpl implements LocalPostsSource {
  static const _PAGE_SIZE = 20;

  final WalletSource _walletSource;

  final DbHelper _helper = DbHelper();
  final StreamController<Post> _streamController = StreamController<Post>();

  /// Public constructor
  LocalPostsSourceImpl({@required WalletSource walletSource})
      : assert(walletSource != null),
        _walletSource = walletSource;

  Future<void> _insertPost(Post post) async {
    final database = await _helper.database;

    // Check if there is a post with the same external reference
    // We are using it to reference the internal id of the post
    final externalId = getPostIdByReference(post.externalReference);
    if (externalId == null) {
      // The post is being created from outside, so we need to create a new
      // external reference so that we can store it locally
      post = post.copyWith(
        externalReference: createPostExternalReference(post.id),
      );
    } else {
      // The post does already exist locally so we need to remove it before
      // reinserting it. This allows us to have a more clean local history without
      // duplicated likes or comments
      await deletePost(externalId);
    }

    // Insert the post
    // This will automatically update any conflicting post that has the same
    // external reference (and thus the same local id)
    await database.insert(
      DbHelper.TABLE_POSTS,
      _helper.postToMap(post),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Insert the likes
    for (int index = 0; index < post.likes.length; index++) {
      await database.insert(
        DbHelper.TABLE_LIKES,
        _helper.likeToMap(post.id, post.likes[index]),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<Post> _getPostData(Map<String, dynamic> dbPost) async {
    // Convert the post
    final post = _helper.postFromMap(dbPost, [], []);

    final database = await _helper.database;

    // Get the likes
    final dbLikes = await database.query(
      DbHelper.TABLE_LIKES,
      where: "${DbHelper.KEY_LIKED_POST_ID} = ?",
      whereArgs: [post.id],
    );
    final likes = dbLikes.map((m) => _helper.likeFromMap(m)).toList();

    // Get the comments
    final dbComments = await database.query(
      DbHelper.TABLE_POSTS,
      where: "${DbHelper.KEY_PARENT_ID} = ?",
      whereArgs: [post.id],
    );
    final commentsIds =
        dbComments.map((m) => m[DbHelper.KEY_ID] as String).toList();

    return post.copyWith(
      likes: likes,
      commentsIds: commentsIds,
    );
  }

  @override
  Stream<Post> get postsStream => _streamController.stream;

  @override
  Future<Post> getPostById(String postId) async {
    if (postId == null || postId.isEmpty) {
      // Post id is null, return null
      return null;
    }

    // Read the post
    final database = await _helper.database;
    final dbPost = await database.query(
      DbHelper.TABLE_POSTS,
      where: "${DbHelper.KEY_ID} = ?",
      whereArgs: [postId],
    );

    if (dbPost.isEmpty) {
      // Nothing found, return null
      return null;
    }

    // Get the other data
    return await _getPostData(dbPost[0]);
  }

  @override
  Future<List<Post>> getPostComments(String postId) async {
    final database = await _helper.database;

    // Get all the comments
    final dbComments = await database.query(
      DbHelper.TABLE_POSTS,
      where: "${DbHelper.KEY_PARENT_ID} = ?",
      whereArgs: [postId],
    );
    final commentsIds =
        dbComments.map((m) => m[DbHelper.KEY_ID] as String).toList();

    // Get the comments details
    return Future.wait(commentsIds.map((id) async {
      return getPostById(id);
    }).toList());
  }

  @override
  Future<List<Post>> getPostsToSync() async {
    final database = await _helper.database;
    final dbPosts = await database.query(
      DbHelper.TABLE_POSTS,
      where: "${DbHelper.KEY_STATUS} != ?",
      whereArgs: [PostStatus.SYNCED.toString()],
    );

    final List<Post> posts = [];
    for (int index = 0; index < dbPosts.length; index++) {
      posts.add(await _getPostData(dbPosts[index]));
    }
    return posts;
  }

  @override
  Future<List<Post>> getPosts(int page) async {
    final database = await _helper.database;
    final dbPosts = await database.query(
      DbHelper.TABLE_POSTS,
      orderBy: "cast(${DbHelper.KEY_ID} as int) DESC",
      limit: _PAGE_SIZE,
      offset: page * _PAGE_SIZE,
    );

    final List<Post> posts = [];
    for (int index = 0; index < dbPosts.length; index++) {
      posts.add(await _getPostData(dbPosts[index]));
    }
    return posts;
  }

  @override
  Future<void> savePost(Post post) async {
    // Update the liked field
    final address = await _walletSource.getAddress();
    post = post.copyWith(liked: post.containsLikeFromUser(address));

    // Update the isUserOwner field
    post = post.copyWith(ownerIsUser: post.owner == address);

    // Save the post
    print('Saving post with id ${post.id}');
    await _insertPost(post);

    // Emit the saved post
    _streamController.add(post);
  }

  @override
  Future<void> savePosts(List<Post> posts) async {
    await Future.wait(posts.map((post) => savePost(post)));
  }

  @override
  Future<void> deletePost(String postId) async {
    final database = await _helper.database;

    // Delete the post
    await database.delete(
      DbHelper.TABLE_POSTS,
      where: "${DbHelper.KEY_ID} = ? OR ${DbHelper.KEY_PARENT_ID} = ?",
      whereArgs: [postId, postId],
    );

    // Delete the likes
    await database.delete(
      DbHelper.TABLE_LIKES,
      where: "${DbHelper.KEY_LIKED_POST_ID} = ?",
      whereArgs: [postId],
    );
  }
}
