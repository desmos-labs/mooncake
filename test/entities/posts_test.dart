import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/entities/entities.dart';

import '../sources/posts/mocks.dart';

void main() {
  group('fromJson', () {
    /// Allows to load a post from the JSON file having the given name.
    Future<Post> loadPost(String fileName) async {
      final file = new File('test_resources/posts/$fileName');
      final json = jsonDecode(await file.readAsString());
      return Post.fromJson(json);
    }

    test('fromJson works with optional data', () async {
      final post = await loadPost("post_valid_optdata.json");
      expect(post.id, "1");
      expect(post.message, "This is a post");
      expect(post.optionalData.isNotEmpty, true);
      expect(
        post.optionalData["external_reference"],
        "dwitter-2019-12-13T08:51:32.262217",
      );
    });

    test('fromJson works with children', () async {
      final post = await loadPost("post_valid_children.json");
      expect(post.id, "86");
      expect(post.message, "2");
      expect(post.commentsIds, ["87", "88"]);
    });

    test('fromJson works with reactions', () async {
      final post = await loadPost("post_valid_reactions.json");
      expect(post.id, "77");
      expect(post.message, "Happy birthday Leo! 🎂🎉🎊");
      expect(post.reactions, [
        Reaction(
          owner: "desmos1z97x0m5zmq0502hha4s0z36hpy9zray3cq2a67",
          value: "🎉",
        ),
        Reaction(
          owner: "desmos16f9wz7yg44pjfhxyn22kycs0qjy778ng877usl",
          value: "😃",
        ),
        Reaction(
          owner: "desmos16f9wz7yg44pjfhxyn22kycs0qjy778ng877usl",
          value: "😍",
        ),
      ]);
    });
  });

  test('toJson', () {
    final json = testPost.toJson();
    expect(json["hasParent"], isNull);
    expect(json["dateTime"], isNull);

    final recovered = Post.fromJson(json);
    expect(recovered, testPost);
  });

  test('getDateStringNow', () {
    expect(Post.getDateStringNow() == Post.getDateStringNow(), isFalse);
  });

  test('hasParent', () {
    expect(
      testPost.copyWith(parentId: null).hasParent,
      isFalse,
      reason: "null parent should return false",
    );

    expect(
      testPost.copyWith(parentId: "  ").hasParent,
      isFalse,
      reason: "empty parent should return false",
    );

    expect(
      testPost.copyWith(parentId: "0").hasParent,
      isFalse,
      reason: "parent 0 should return false",
    );

    expect(testPost.copyWith(parentId: "10").hasParent, true);
  });

  test('dateTime', () {
    final post = testPost.copyWith(created: "2020-01-01T15:00:00.000Z");
    expect(post.dateTime, DateTime.utc(2020, 1, 1, 15, 0, 0, 0, 0));
  });

  test('compareTo', () {
    final first = testPost.copyWith(created: "2020-01-01T15:00:00.000Z");
    final second = testPost.copyWith(created: "2019-12-31T18:00:00.000Z");

    expect(-1, second.compareTo(first));
    expect(0, first.compareTo(first));
    expect(1, first.compareTo(second));
  });
}
