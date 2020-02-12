import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

/// Implementation of [LocalPostsSource] that deals with local data.
class LocalPostsSourceImpl implements LocalPostsSource {
  final String _dbName;

  final store = StoreRef.main();
  final StreamController<Post> _streamController = StreamController<Post>();

  /// Public constructor
  LocalPostsSourceImpl({
    @required String dbName,
  })  : assert(dbName != null && dbName.isNotEmpty),
        this._dbName = dbName;

  Future<Database> get database async {
    final path = await getApplicationDocumentsDirectory();
    await path.create(recursive: true);
    return databaseFactoryIo.openDatabase(join(path.path, this._dbName));
  }

  @override
  Stream<Post> get postsStream => _streamController.stream;

  /// Returns the keys that should be used inside the database to store the
  /// given [post].
  String _getPostKey(Post post) => post.created + post.owner;

  @override
  Future<void> savePost(Post post, {bool emit = true}) async {
    final database = await this.database;
    await store.record(_getPostKey(post)).put(database, post.toJson());

    if (emit) {
      _streamController.add(post);
    }
  }

  @override
  Future<void> savePosts(List<Post> posts, {bool emit = true}) async {
    final database = await this.database;
    final keys = posts.map((p) => _getPostKey(p)).toList();
    final values = posts.map((p) => p.toJson()).toList();
    await store.records(keys).put(database, values);

    if (emit) {
      posts.forEach((p) => _streamController.add(p));
    }
  }

  @override
  Future<Post> getPostById(String postId) async {
    final database = await this.database;
    final finder = Finder(filter: Filter.equals("id", postId));

    final record = await store.findFirst(database, finder: finder);
    if (record == null) {
      return null;
    }

    return Post.fromJson(record.value);
  }

  @override
  Future<List<Post>> getPostComments(String postId) async {
    final database = await this.database;
    final finder = Finder(filter: Filter.equals("parent_id", postId));

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
  Future<void> deletePost(String postId) async {
    final database = await this.database;
    final finder = Finder(filter: Filter.equals(Post.ID_FIELD, postId));

    await store.delete(database, finder: finder);
  }
}
