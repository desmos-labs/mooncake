import 'dart:async';

import 'package:desmosdemo/entities/entities.dart';
import 'package:desmosdemo/repositories/repositories.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';

import 'db_helper.dart';

/// Implementation of [PostsSource] that deals with local data.
class LocalPostsSource implements PostsSource {
  final WalletSource _walletSource;

  final DbHelper helper = DbHelper();
  final StreamController<Post> _streamController = StreamController<Post>();

  /// Public constructor
  LocalPostsSource({@required WalletSource walletSource})
      : assert(walletSource != null),
        _walletSource = walletSource;

  Future<void> _insertPost(Post post) async {
    final database = await helper.database;

    // Insert the likes
    for (int index = 0; index < post.likes.length; index++) {
      await database.insert(
        DbHelper.TABLE_LIKES,
        helper.likeToMap(post.id, post.likes[index]),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    // Insert the comments
    for (int index = 0; index < post.commentsIds.length; index++) {
      await database.insert(
        DbHelper.TABLE_COMMENTS,
        helper.commentToMap(post.id, post.commentsIds[index]),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    // Insert the post
    await database.insert(
      DbHelper.TABLE_POSTS,
      helper.postToMap(post),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Post> _getPostData(Map<String, dynamic> dbPost) async {
    // Convert the post
    final post = helper.postFromMap(dbPost, [], []);

    final database = await helper.database;

    // Get the likes
    final dbLikes = await database.query(
      DbHelper.TABLE_LIKES,
      where: "${DbHelper.KEY_LIKED_POST_ID} = ?",
      whereArgs: [post.id],
    );
    final likes = dbLikes.map((m) => helper.likeFromMap(m)).toList();

    // Get the comments
    final dbComments = await database.query(
      DbHelper.TABLE_COMMENTS,
      where: "${DbHelper.KEY_COMMENTED_POST_ID} = ?",
      whereArgs: [post.id],
    );
    final comments = dbComments.map((m) => helper.commentIdFromMap(m)).toList();

    return post.copyWith(
      likes: likes,
      commentsIds: comments,
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
    final database = await helper.database;
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
  Future<List<Post>> getPosts() async {
    final database = await helper.database;
    final dbPosts = await database.query(DbHelper.TABLE_POSTS);

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
    final database = await helper.database;

    // Delete the post
    await database.delete(
      DbHelper.TABLE_POSTS,
      where: "${DbHelper.KEY_ID} = ?",
      whereArgs: [postId],
    );

    // Deleted the comments entries
    await database.delete(
      DbHelper.TABLE_COMMENTS,
      where: "${DbHelper.KEY_COMMENTED_POST_ID} = ? OR ${DbHelper.KEY_COMMENT_ID} = ?",
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
