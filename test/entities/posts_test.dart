import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/entities/entities.dart';

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
}
