import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

/// Implementation of [LocalPostsSource] that deals with local data.
class LocalPostsSourceImpl implements LocalPostsSource {
  // Database
  final store = StoreRef.main();
  final Database database;

  /// Public constructor
  LocalPostsSourceImpl({
    this.database,
  }) : assert(database != null);

  /// Returns the keys that should be used inside the database to store the
  /// given [post].
  @visibleForTesting
  String getPostKey(Post post) {
    return DateFormat(Post.DATE_FORMAT).format(post.dateTime) +
        post.owner.address;
  }

  final List<Post> Function(
    List<RecordSnapshot<dynamic, dynamic>>,
  ) postsMapper = (snapshots) {
    return List<Post>.generate(
      snapshots.length ?? 0,
      (index) => Post.fromJson(snapshots[index].value),
    );
  };

  @override
  Stream<List<Post>> get postsStream {
    final finder = Finder(sortOrders: [SortOrder(Post.DATE_FIELD, false)]);
    return store.query(finder: finder).onSnapshots(database).map(postsMapper);
  }

  @override
  Stream<List<Post>> homePostsStream(int limit) {
    final finder = Finder(
      filter: Filter.or([
        Filter.equals(Post.PARENT_ID_FIELD, null),
        Filter.equals(Post.PARENT_ID_FIELD, "0"),
      ]),
      sortOrders: [SortOrder(Post.DATE_FIELD, false)],
      limit: limit,
    );
    return store.query(finder: finder).onSnapshots(database).map(postsMapper);
  }

  @override
  Stream<Post> singlePostStream(String postId) {
    final finder = Finder(filter: Filter.equals(Post.ID_FIELD, postId));
    return store
        .query(finder: finder)
        .onSnapshots(database)
        .map(postsMapper)
        .map((event) => event?.isNotEmpty == true ? event[0] : null);
  }

  @override
  Future<Post> getSinglePost(String postId) async {
    final finder = Finder(filter: Filter.equals(Post.ID_FIELD, postId));
    final record = await store.findFirst(database, finder: finder);
    if (record == null) {
      return null;
    }

    return Post.fromJson(record.value);
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
    return records.map((record) => Post.fromJson(record.value)).toList();
  }

  @override
  Stream<List<Post>> getPostComments(String postId) {
    return postsStream.map((list) {
      return list.where((post) => post.parentId == postId).toList();
    });
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
    return records.map((record) => Post.fromJson(record.value)).toList();
  }

  @override
  Future<void> savePost(Post post) async {
    await database.transaction((txn) async {
      await store.record(getPostKey(post)).put(txn, post.toJson());
    });
  }

  List<Post> _mergePosts(List<Post> existingPosts, List<Post> newPosts) {
    for (int index = 0; index < newPosts.length; index++) {
      final existing = existingPosts[index];
      final updated = newPosts[index];

      Map<String, String> optionalData = updated.optionalData;
      if (existing?.optionalData != null) {
        optionalData.addAll(existing.optionalData);
      }

      Set<PostMedia> medias = updated.medias.toSet();
      if (existing?.medias != null) {
        medias.addAll(existing.medias);
      }

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
        optionalData: optionalData,
        medias: medias.toList(),
        reactions: reactions.toList(),
        commentsIds: commentIds.toList(),
      );
    }
  }

  @override
  Future<void> savePosts(List<Post> posts, {bool merge = false}) async {
    final values = posts.map((e) => e.toJson()).toList();
    await database.transaction((txn) async {
      final keys = posts.map((e) => getPostKey(e)).toList();

      if (merge) {
        final existingValues = (await store.records(keys).get(txn))
            .map((e) => e == null ? null : Post.fromJson(e))
            .toList();
        _mergePosts(existingValues, posts);
      }

      await store.records(keys).put(txn, values);
    });
  }
}
