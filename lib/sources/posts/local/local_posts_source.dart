import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/entities/posts/export.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:mooncake/utils/measure_exec_time.dart';
import 'package:sembast/sembast.dart';

import 'converter.dart';

/// Implementation of [LocalPostsSource] that deals with local data.
class LocalPostsSourceImpl implements LocalPostsSource {
  final StoreRef _store = StoreRef.main();
  final Database _database;

  final UsersRepository _usersRepository;

  /// Public constructor
  LocalPostsSourceImpl({
    @required Database database,
    @required UsersRepository usersRepository,
  })  : assert(database != null),
        _database = database,
        assert(usersRepository != null),
        _usersRepository = usersRepository;

  /// Returns the keys that should be used inside the database to store the
  /// given [post].
  @visibleForTesting
  String getPostKey(Post post) {
    return post.hashContents();
  }

  /// Returns a [Filter] that allows to filter out all the posts that are
  /// created from a blocked user that is present inside the [users] list.
  Filter _getBlockedUsersFilter(List<String> users) {
    return Filter.custom((record) {
      return !users.contains(record['user']['address']);
    });
  }

  @override
  Stream<List<Post>> get postsStream {
    return _usersRepository.blockedUsersStream.map((users) {
      return Finder(
        filter: Filter.and([
          Filter.equals(Post.HIDDEN_FIELD, false),
          _getBlockedUsersFilter(users),
        ]),
        sortOrders: [SortOrder(Post.DATE_FIELD, false)],
      );
    }).asyncExpand((finder) {
      return _store
          .query(finder: finder)
          .onSnapshots(_database)
          .asyncMap(PostsConverter.deserializePosts);
    });
  }

  /// Given a [limit], returns the [Finder] that should be used to get
  /// the home posts returning a list of the [limit] size.
  Finder _homeFinder({int start = 0, int limit, List<String> blockedUsers}) {
    return Finder(
      filter: Filter.and([
        Filter.or([
          Filter.equals(Post.PARENT_ID_FIELD, null),
          Filter.equals(Post.PARENT_ID_FIELD, ''),
        ]),
        Filter.equals(Post.HIDDEN_FIELD, false),
        _getBlockedUsersFilter(blockedUsers),
      ]),
      sortOrders: [SortOrder(Post.DATE_FIELD, false)],
      offset: start,
      limit: limit,
    );
  }

  @override
  Stream<List<Post>> homePostsStream(int limit) {
    return _usersRepository.blockedUsersStream.asyncExpand((users) {
      return _store
          .query(finder: _homeFinder(limit: limit, blockedUsers: users))
          .onSnapshots(_database)
          .asyncMap(PostsConverter.deserializePosts);
    });
  }

  /// Given a [postId], returns the [Finder] that should be used to filter
  /// the posts and find the one having the given id.
  Finder _postFinder(String postId) {
    return Finder(filter: Filter.equals(Post.ID_FIELD, postId));
  }

  @override
  Stream<Post> singlePostStream(String postId) {
    return _store
        .query(finder: _postFinder(postId))
        .onSnapshots(_database)
        .asyncMap(PostsConverter.deserializePosts)
        .map((event) => event.isEmpty ? null : event.first);
  }

  @override
  Future<List<Post>> getHomePosts({int start = 0, int limit = 50}) async {
    final users = await _usersRepository.getBlockedUsers();
    final finder = _homeFinder(start: start, limit: limit, blockedUsers: users);
    return _store
        .find(_database, finder: finder)
        .then(PostsConverter.deserializePosts);
  }

  @override
  Future<Post> getPostById(String postId) async {
    final record = await _store.findFirst(
      _database,
      finder: _postFinder(postId),
    );
    return record == null ? null : PostsConverter.deserializePost(record);
  }

  @override
  Future<List<Post>> getPostsByTxHash(String txHash) async {
    final finder = Finder(
      filter: Filter.and([
        Filter.equals(Post.STATUS_VALUE_FIELD, PostStatusValue.TX_SENT.value),
        Filter.equals(Post.STATUS_DATA_FIELD, txHash),
      ]),
    );

    final records = await _store.find(_database, finder: finder);
    return PostsConverter.deserializePosts(records);
  }

  /// Given a [postId] returns the [Finder] that should be used in order
  /// to get all the comments for the post having such id.
  Finder _commentsFinder(String postId, List<String> blockedUsers) {
    return Finder(
      filter: Filter.and([
        Filter.equals(Post.HIDDEN_FIELD, false),
        Filter.equals(Post.PARENT_ID_FIELD, postId),
        _getBlockedUsersFilter(blockedUsers),
      ]),
      sortOrders: [SortOrder(Post.DATE_FIELD, false)],
    );
  }

  @override
  Stream<List<Post>> getPostCommentsStream(String postId) {
    return _usersRepository.blockedUsersStream.asyncExpand((users) {
      return _store
          .query(finder: _commentsFinder(postId, users))
          .onSnapshots(_database)
          .asyncMap(PostsConverter.deserializePosts);
    });
  }

  @override
  Future<List<Post>> getPostComments(String postId) async {
    final blockedUsers = await _usersRepository.getBlockedUsers();
    final records = await _store.find(
      _database,
      finder: _commentsFinder(postId, blockedUsers),
    );
    return PostsConverter.deserializePosts(records);
  }

  @override
  Future<List<Post>> getPostsToSync(String address) async {
    final finder = Finder(
      filter: Filter.and([
        Filter.equals(
          Post.STATUS_VALUE_FIELD,
          PostStatusValue.STORED_LOCALLY.value,
        ),
        Filter.equals(
          Post.STATUS_DATA_FIELD,
          address,
        ),
      ]),
    );

    final records = await _store.find(_database, finder: finder);
    return PostsConverter.deserializePosts(records);
  }

  @override
  Future<void> savePost(Post post, {bool merge = false}) async {
    await _database.transaction((txn) async {
      if (merge) {
        final existingJson = await _store.record(getPostKey(post)).get(txn);
        final existing = await PostsConverter.deserializePost(existingJson);
        post = mergePost(existing, post);
      }

      final value = await PostsConverter.serializePost(post);
      final key = getPostKey(post);
      await _store.record(key).put(txn, value);
    });
  }

  /// Takes a list of [existingPosts] and a list of [newPosts], and merges
  /// them together.
  /// Merging means that the reactions and comments ids will be unified, but
  /// all the other information will be taken from the [newPosts] list elements.
  ///
  /// The two lists should have the same length, and for each `i`,
  /// then `newPosts[i]` should represent the same post as `existingPosts[i]`.
  /// If [existingPosts] does not contain al posts present inside [newPosts],
  /// then the associated post can be null.
  @visibleForTesting
  List<Post> mergePosts(List<Post> existingPosts, List<Post> newPosts) {
    final merged = List<Post>(newPosts.length);
    for (var index = 0; index < merged.length; index++) {
      merged[index] = mergePost(existingPosts[index], newPosts[index]);
    }
    return merged;
  }

  @visibleForTesting
  Post mergePost(Post existing, Post updated) {
    final eq = ListEquality().equals;
    final contentsEquals = eq(existing?.reactions, updated.reactions) &&
        eq(existing?.commentsIds, updated.commentsIds) &&
        existing?.poll == updated.poll;

    if (contentsEquals) {
      return updated.status.value == PostStatusValue.TX_SUCCESSFULL
          ? updated
          : existing;
    }

    var reactions = updated.reactions.toSet();
    if (existing?.reactions != null) {
      reactions.addAll(existing.reactions);
    }

    var commentIds = updated.commentsIds.toSet();
    if (existing?.commentsIds != null) {
      commentIds.addAll(existing.commentsIds);
    }

    var postPoll = updated.poll;
    if (existing?.poll != null && updated.poll != null) {
      var answers = (updated.poll.userAnswers ?? []).toSet();
      answers.addAll(existing.poll.userAnswers ?? []);
      postPoll = postPoll.copyWith(userAnswers: answers.toList());
    }

    return updated.copyWith(
      status: existing?.status,
      reactions: reactions.toList(),
      commentsIds: commentIds.toList(),
      poll: postPoll,
    );
  }

  @override
  Future<void> savePosts(List<Post> posts, {bool merge = false}) async {
    final keys = posts.map((e) => getPostKey(e)).toList();

    await _database.transaction((txn) async {
      if (merge) {
        final existingValues = await measureExecTime(() async {
          final posts = await _store.records(keys).get(txn);
          return PostsConverter.deserializePostsSync(posts);
        }, name: 'Local posts reading');
        posts = mergePosts(existingValues, posts);
      }

      final values = await measureExecTime(() async {
        return PostsConverter.serializePostsSync(posts);
      }, name: 'Local posts conversion');

      await measureExecTime(() async {
        return _store.records(keys).put(txn, values);
      }, name: 'Local posts storing');
    });
  }

  @override
  Future<void> deletePosts() async {
    await _store.delete(_database);
  }

  @override
  Future<void> deletePost(Post post) async {
    await _store.record(getPostKey(post)).delete(_database);
  }
}
