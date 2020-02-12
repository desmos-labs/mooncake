import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/sources/sources.dart';

import 'mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Temporary directory where to store the test databases
  final tempDir = Directory("./tmp");

  LocalPostsSourceImpl source;

  setUpAll(() {
    // Mock for the path provider
    final channel = MethodChannel('plugins.flutter.io/path_provider');
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return tempDir.path;
    });

    // Create the temp dir where to save the database
    tempDir.createSync();
  });

  tearDownAll(() {
    // Delete the temp dir inside which databases have been created
    tempDir.deleteSync(recursive: true);
  });

  setUp(() {
    // Create the local source
    source = LocalPostsSourceImpl(
      dbName: DateTime.now().toIso8601String(),
    );
  });

  void checkStreamDoesNotEmit(Stream stream) {
    stream.listen((_) => throw Exception("No item should be emitted"));
  }

  group('Single post', () {
    test('saving saves a post and does not emit it', () async {
      await source.savePost(testPost, emit: false);
      checkStreamDoesNotEmit(source.postsStream);

      final database = await source.database;
      final posts = await source.store.find(database);
      expect(posts, hasLength(1));
      expect(posts[0].value, testPost.toJson());
    });

    test('saving saves a post and emits it', () async {
      await source.savePost(testPost, emit: true);

      final database = await source.database;
      final posts = await source.store.find(database);
      expect(posts, hasLength(1));
      expect(posts[0].value, testPost.toJson());

      final emittedPost = await source.postsStream.first;
      expect(emittedPost, testPost);
    });

    test('reading returns null when no post is found', () async {
      final post = await source.getPostById("inexsitinst post id");
      expect(post, isNull);
    });

    test('reading returns the valid post when it exists', () async {
      await source.savePost(testPost);
      final stored = await source.getPostById(testPost.id);
      expect(stored, testPost);
    });

    test('deleting works with non existing post', () async {
      final postId = "post-id";
      await source.deletePost(postId);

      final stored = await source.getPostById(postId);
      expect(stored, isNull);
    });

    test('deleting works properly with existing post', () async {
      await source.savePost(testPost);
      expect(await source.getPostById(testPost.id), testPost);

      await source.deletePost(testPost.id);
      expect(await source.getPostById(testPost.id), isNull);
    });
  });

  group('Posts', () {
    test('saving saves a list of posts and does not emit them', () async {
      await source.savePosts(testPosts, emit: false);
      checkStreamDoesNotEmit(source.postsStream);

      final database = await source.database;
      final posts = await source.store.find(database);
      expect(posts, hasLength(testPosts.length));
      expect(posts.map((e) => e.value), testPosts.map((e) => e.toJson()));
    });

    test('saving saves a list of posts and emits them', () async {
      int counter = 0;
      source.postsStream.listen((_) => counter++);

      await source.savePosts(testPosts, emit: true);

      final database = await source.database;
      final posts = await source.store.find(database);
      expect(posts, hasLength(testPosts.length));
      expect(posts.map((e) => e.value), testPosts.map((e) => e.toJson()));
      expect(counter, testPosts.length);
    });

    test('reading returns an empty list with no posts', () async {
      final posts = await source.getPosts();
      expect(posts, isEmpty);
    });

    test('reaading returns proper value', () async {
      final posts = [
        Post(
          id: "1",
          parentId: "10",
          message: "Hello dreamers! ✨",
          created: "2020-01-21T13:16:10.123Z",
          lastEdited: "",
          allowsComments: true,
          subspace: "desmos",
          optionalData: {},
          owner: "desmos1y35fex9005709966jxkcqcz2vdvmtfyaj4x93h",
          reactions: [],
          commentsIds: [],
          status: PostStatus(value: PostStatusValue.ERRORED),
        ),
        Post(
          id: "2",
          parentId: "0",
          message: "Welcome to a new world of social media 🗣️",
          created: "2020-01-21T13:20:10.123Z",
          lastEdited: "",
          allowsComments: true,
          subspace: "desmos",
          optionalData: {},
          owner: "desmos16r460yaek3uqncjhnxez8v327qnxjw5k0crg9x",
          reactions: [
            Reaction(
              value: "😲",
              owner: "desmos1y35fex9005709966jxkcqcz2vdvmtfyaj4x93h",
            ),
            Reaction(
              value: "💯",
              owner: "desmos16f9wz7yg44pjfhxyn22kycs0qjy778ng877usl",
            )
          ],
          commentsIds: ["10"],
          status: PostStatus(value: PostStatusValue.TO_BE_SYNCED),
        ),
        Post(
          id: "3",
          parentId: "11",
          message: "Are you ready to get a piece of the cake? 🥮️",
          created: "2020-01-21T13:21:10.123Z",
          lastEdited: "",
          allowsComments: true,
          subspace: "desmos",
          optionalData: {},
          owner: "desmos15x3e6md5gdcsszc2nx88trnn85nn0qzgjwl9pj",
          reactions: [],
          commentsIds: [],
          status: PostStatus(value: PostStatusValue.SYNCING),
        ),
        Post(
          id: "4",
          parentId: "11",
          message: "Are you ready to get a piece of the cake? 🥮️",
          created: "2020-01-21T13:21:10.123Z",
          lastEdited: "",
          allowsComments: true,
          subspace: "desmos",
          optionalData: {},
          owner: "desmos16f9wz7yg44pjfhxyn22kycs0qjy778ng877usl",
          reactions: [],
          commentsIds: [],
          status: PostStatus(value: PostStatusValue.SYNCED),
        ),
      ];
      await source.savePosts(posts, emit: false);

      final stored = await source.getPosts();
      expect(stored, hasLength(posts.length));

      reverse(posts);
      expect(stored, posts);
    });
  });

  group('Comments', () {
    test('reading returns an empty list with no comments', () async {
      final comments = await source.getPostComments("inexisting post");
      expect(comments, isEmpty);
    });

    test('reading returns proper comments list', () async {
      final parentId = "10";
      final comments = [
        Post(
          id: "1",
          parentId: parentId,
          message: "Hello dreamers! ✨",
          created: "2020-01-21T13:16:10.123Z",
          lastEdited: "",
          allowsComments: true,
          subspace: "desmos",
          optionalData: {},
          owner: "desmos1y35fex9005709966jxkcqcz2vdvmtfyaj4x93h",
          reactions: [],
          commentsIds: [],
          status: PostStatus(value: PostStatusValue.SYNCED),
        ),
        Post(
          id: "2",
          parentId: "0",
          message: "Welcome to a new world of social media 🗣️",
          created: "2020-01-21T13:20:10.123Z",
          lastEdited: "",
          allowsComments: true,
          subspace: "desmos",
          optionalData: {},
          owner: "desmos16r460yaek3uqncjhnxez8v327qnxjw5k0crg9x",
          reactions: [
            Reaction(
              value: "😲",
              owner: "desmos1y35fex9005709966jxkcqcz2vdvmtfyaj4x93h",
            ),
            Reaction(
              value: "💯",
              owner: "desmos16f9wz7yg44pjfhxyn22kycs0qjy778ng877usl",
            )
          ],
          commentsIds: ["10"],
          status: PostStatus(value: PostStatusValue.SYNCED),
        ),
        Post(
          id: "3",
          parentId: parentId,
          message: "Are you ready to get a piece of the cake? 🥮️",
          created: "2020-01-21T13:21:10.123Z",
          lastEdited: "",
          allowsComments: true,
          subspace: "desmos",
          optionalData: {},
          owner: "desmos15x3e6md5gdcsszc2nx88trnn85nn0qzgjwl9pj",
          reactions: [],
          commentsIds: [],
          status: PostStatus(value: PostStatusValue.SYNCING),
        ),
      ];
      await source.savePosts(comments, emit: false);

      final storedComments = await source.getPostComments(parentId);
      expect(storedComments, hasLength(2));
      expect(storedComments, contains(comments[0]));
      expect(storedComments, contains(comments[2]));
    });
  });

  group('Syncing posts', () {
    test('reading returns empty list with no posts', () async {
      final posts = await source.getPostsToSync();
      expect(posts, isEmpty);
    });

    test('reading returns proper list', () async {
      final posts = [
        Post(
          id: "1",
          parentId: "10",
          message: "Hello dreamers! ✨",
          created: "2020-01-21T13:16:10.123Z",
          lastEdited: "",
          allowsComments: true,
          subspace: "desmos",
          optionalData: {},
          owner: "desmos1y35fex9005709966jxkcqcz2vdvmtfyaj4x93h",
          reactions: [],
          commentsIds: [],
          status: PostStatus(value: PostStatusValue.ERRORED),
        ),
        Post(
          id: "2",
          parentId: "0",
          message: "Welcome to a new world of social media 🗣️",
          created: "2020-01-21T13:20:10.123Z",
          lastEdited: "",
          allowsComments: true,
          subspace: "desmos",
          optionalData: {},
          owner: "desmos16r460yaek3uqncjhnxez8v327qnxjw5k0crg9x",
          reactions: [
            Reaction(
              value: "😲",
              owner: "desmos1y35fex9005709966jxkcqcz2vdvmtfyaj4x93h",
            ),
            Reaction(
              value: "💯",
              owner: "desmos16f9wz7yg44pjfhxyn22kycs0qjy778ng877usl",
            )
          ],
          commentsIds: ["10"],
          status: PostStatus(value: PostStatusValue.TO_BE_SYNCED),
        ),
        Post(
          id: "3",
          parentId: "11",
          message: "Are you ready to get a piece of the cake? 🥮️",
          created: "2020-01-21T13:21:10.123Z",
          lastEdited: "",
          allowsComments: true,
          subspace: "desmos",
          optionalData: {},
          owner: "desmos15x3e6md5gdcsszc2nx88trnn85nn0qzgjwl9pj",
          reactions: [],
          commentsIds: [],
          status: PostStatus(value: PostStatusValue.SYNCING),
        ),
        Post(
          id: "4",
          parentId: "11",
          message: "Are you ready to get a piece of the cake? 🥮️",
          created: "2020-01-21T13:21:10.123Z",
          lastEdited: "",
          allowsComments: true,
          subspace: "desmos",
          optionalData: {},
          owner: "desmos16f9wz7yg44pjfhxyn22kycs0qjy778ng877usl",
          reactions: [],
          commentsIds: [],
          status: PostStatus(value: PostStatusValue.SYNCED),
        ),
      ];
      await source.savePosts(posts, emit: false);

      final postsToBeSynced = await source.getPostsToSync();
      expect(postsToBeSynced, hasLength(2));
      expect(postsToBeSynced, contains(posts[0]));
      expect(postsToBeSynced, contains(posts[1]));
    });
  });
}
