import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:sembast/sembast.dart';

import 'converter.dart';

/// Implementation of [LocalPostsSource] that deals with local data.
class LocalPostsSourceImpl implements LocalPostsSource {
  // Database
  final store = StoreRef.main();
  final Database database;

  /// Public constructor
  LocalPostsSourceImpl({this.database}) : assert(database != null);

  /// Returns the keys that should be used inside the database to store the
  /// given [post].
  @visibleForTesting
  String getPostKey(Post post) {
    return DateFormat(Post.DATE_FORMAT).format(post.dateTime) +
        post.owner.address;
  }

  @override
  Stream<List<Post>> get postsStream {
    final finder = Finder(
      filter: Filter.equals(Post.HIDDEN_FIELD, false),
      sortOrders: [SortOrder(Post.DATE_FIELD, false)],
    );

    return store
        .query(finder: finder)
        .onSnapshots(database)
        .asyncMap(PostsConverter.deserializePosts);
  }

  Finder _homeFinder(int limit) {
    return Finder(
      filter: Filter.and([
        Filter.or([
          Filter.equals(Post.PARENT_ID_FIELD, null),
          Filter.equals(Post.PARENT_ID_FIELD, "0"),
        ]),
        Filter.equals(Post.HIDDEN_FIELD, false),
      ]),
      sortOrders: [SortOrder(Post.DATE_FIELD, false)],
      limit: limit,
    );
  }

  @override
  Stream<List<Post>> homePostsStream(int limit) {
    return store
        .query(finder: _homeFinder(limit))
        .onSnapshots(database)
        .asyncMap(PostsConverter.deserializePosts);
  }

  @override
  Stream<Post> singlePostStream(String postId) {
    final finder = Finder(filter: Filter.equals(Post.ID_FIELD, postId));
    return store
        .query(finder: finder)
        .onSnapshots(database)
        .asyncMap(PostsConverter.deserializePosts)
        .map((event) => event?.isNotEmpty == true ? event[0] : null);
  }

  @override
  Future<Post> getSinglePost(String postId) async {
    final finder = Finder(filter: Filter.equals(Post.ID_FIELD, postId));
    final record = await store.findFirst(database, finder: finder);
    if (record == null) {
      return null;
    }

    return PostsConverter.deserializePost(record);
  }

  @override
  Future<List<Post>> getPostsByTxHash(String txHash) async {
    final finder = Finder(
      filter: Filter.and([
        Filter.equals(Post.STATUS_VALUE_FIELD, PostStatusValue.TX_SENT.value),
        Filter.equals(Post.STATUS_DATA_FIELD, txHash),
      ]),
    );

    final records = await store.find(database, finder: finder);
    return PostsConverter.deserializePosts(records);
  }

  Finder _commentsFinder(String postId) {
    return Finder(
      filter: Filter.and([
        Filter.equals(Post.HIDDEN_FIELD, false),
        Filter.equals(Post.PARENT_ID_FIELD, postId),
      ]),
      sortOrders: [SortOrder(Post.DATE_FIELD, false)],
    );
  }

  @override
  Stream<List<Post>> getPostCommentsStream(String postId) {
    return store
        .query(finder: _commentsFinder(postId))
        .onSnapshots(database)
        .asyncMap(PostsConverter.deserializePosts);
  }

  @override
  Future<List<Post>> getPostComments(String postId) async {
    final records = await store.find(database, finder: _commentsFinder(postId));
    return PostsConverter.deserializePosts(records);
  }

  @override
  Future<List<Post>> getPostsToSync() async {
    final finder = Finder(
      filter: Filter.or([
        Filter.equals(
          Post.STATUS_VALUE_FIELD,
          PostStatusValue.STORED_LOCALLY.value,
        ),
        Filter.equals(
          Post.STATUS_VALUE_FIELD,
          PostStatusValue.ERRORED.value,
        ),
      ]),
    );

    final records = await store.find(database, finder: finder);
    return PostsConverter.deserializePosts(records);
  }

  @override
  Future<void> savePost(Post post) async {
    final value = await PostsConverter.serializePost(post);
    await database.transaction((txn) async {
      await store.record(getPostKey(post)).put(txn, value);
    });
  }

  void _mergePosts(List<Post> existingPosts, List<Post> newPosts) {
    for (int index = 0; index < newPosts.length; index++) {
      final existing = existingPosts[index];
      final updated = newPosts[index];

      Set<Reaction> reactions = updated.reactions.toSet();
      if (existing?.reactions != null) {
        reactions.addAll(existing.reactions);
      }

      Set<String> commentIds = updated.commentsIds.toSet();
      if (existing?.commentsIds != null) {
        commentIds.addAll(existing.commentsIds);
      }

      newPosts[index] = updated.copyWith(
        status: existing?.status,
        reactions: reactions.toList(),
        commentsIds: commentIds.toList(),
      );
    }
  }

  @override
  Future<void> savePosts(List<Post> posts, {bool merge = false}) async {
    final keys = posts.map((e) => getPostKey(e)).toList();

    await database.transaction((txn) async {
      if (merge) {
        final existingValues = await PostsConverter.deserializePosts(
          await store.records(keys).get(txn),
        );
        _mergePosts(existingValues, posts);
      }

      final values = await PostsConverter.serializePosts(posts);
      await store.records(keys).put(txn, values);
    });
  }
}
