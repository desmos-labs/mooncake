import 'dart:async';

import 'package:flutter/foundation.dart';
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
  final String _dbName;
  final store = StoreRef.main();

  // Stream, controller
  final _postsController = BehaviorSubject<List<Post>>();

  /// Public constructor
  LocalPostsSourceImpl({
    @required String dbName,
  })  : assert(dbName != null && dbName.isNotEmpty),
        this._dbName = dbName;

  /// Returns the database used to store the posts date.
  Future<Database> get database async {
    final path = await getApplicationDocumentsDirectory();
    await path.create(recursive: true);
    return databaseFactoryIo.openDatabase(join(path.path, this._dbName));
  }

  /// Returns the keys that should be used inside the database to store the
  /// given [post].
  String getPostKey(Post post) => post.created + post.owner.address;

  @override
  Stream<List<Post>> get postsStream => _postsController.stream;

  @override
  Stream<Post> getPostById(String postId) =>
      postsStream.expand((list) => list).where((post) => post.id == postId);

  @override
  Stream<List<Post>> getPostComments(String postId) => postsStream
      .map((list) => list.where((post) => post.parentId == postId).toList());

  @override
  Future<List<Post>> getPosts() async {
    final database = await this.database;
    final finder = Finder(
      sortOrders: [
        SortOrder(Post.DATE_FIELD, false), // Descending date
        SortOrder(Post.ID_FIELD, false), // Descending id if date is equal
      ],
    );

    final records = await store.find(database, finder: finder);
    return records.map((record) => Post.fromJson(record.value)).toList();
  }

  @override
  Future<List<Post>> getPostsToSync() async {
    final database = await this.database;
    final finder = Finder(
      filter: Filter.or([
        Filter.equals(Post.STATUS_FIELD, PostStatusValue.TO_BE_SYNCED.value),
        Filter.equals(Post.STATUS_FIELD, PostStatusValue.ERRORED.value),
      ]),
    );

    final records = await store.find(database, finder: finder);
    return records.map((record) => Post.fromJson(record.value)).toList();
  }

  /// Saves the given [post], updating its parent as well (if it has one).
  /// If [emit] is true, after the update emits the new list of posts
  /// using the [postsStream].
  Future<void> _savePostAndParent(Post post, {bool emit = false}) async {
    final database = await this.database;
    await store.record(getPostKey(post)).put(database, post.toJson());

    // Update the parent
    if (post.hasParent) {
      final parent = await getPostById(post.parentId).first;
      final comments = parent.commentsIds;
      if (!comments.contains(post.id)) {
        comments.add(post.id);
      }
      _savePostAndParent(parent.copyWith(commentsIds: comments), emit: false);
    }

    // If emit is true, emit the set of posts
    if (emit) {
      final records = await getPosts();
      _postsController.add(records);
    }
  }

  @override
  Future<void> savePost(Post post) => _savePostAndParent(post, emit: true);
}
