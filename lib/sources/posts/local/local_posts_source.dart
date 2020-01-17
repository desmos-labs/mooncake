import 'dart:async';

import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:meta/meta.dart';
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

  Future<Database> get _database async {
    final path = await getApplicationDocumentsDirectory();
    await path.create(recursive: true);
    return databaseFactoryIo.openDatabase(join(path.path, this._dbName));
  }

  @override
  Stream<Post> get postsStream => _streamController.stream;

  @override
  Future<Post> getPostById(String postId) async {
    final database = await this._database;
    final finder = Finder(filter: Filter.equals("id", postId));

    final record = await store.findFirst(database, finder: finder);
    if (record == null) {
      return null;
    }

    return Post.fromJson(record.value);
  }

  @override
  Future<List<Post>> getPostComments(String postId) async {
    final database = await this._database;
    final finder = Finder(filter: Filter.equals("parent_id", postId));

    final records = await store.find(database, finder: finder);
    return records.map((record) => Post.fromJson(record.value)).toList();
  }

  @override
  Future<List<Post>> getPostsToSync() async {
    final database = await this._database;
    final finder = Finder(
      filter:
          Filter.notEquals("status.value", PostStatusValue.SYNCED.toString()),
    );

    final records = await store.find(database, finder: finder);
    return records.map((record) => Post.fromJson(record.value)).toList();
  }

  @override
  Future<List<Post>> getPosts() async {
    final database = await this._database;
    final records = await store.find(database);
    return records.map((record) => Post.fromJson(record.value)).toList();
  }

  @override
  Future<void> savePost(Post post, {bool emit = true}) async {
    final database = await this._database;
    final key = post.owner + post.created;
    await store.record(key).put(database, post.toJson());

    if (emit) {
      _streamController.add(post);
    }
  }

  @override
  Future<void> savePosts(List<Post> posts) async {
    await Future.wait(posts.map((post) => savePost(post)));
  }

  @override
  Future<void> deletePost(String postId) async {
    final database = await this._database;
    final finder = Finder(filter: Filter.equals("id", postId));

    await store.delete(database, finder: finder);
  }
}
