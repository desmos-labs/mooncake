import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/entities/entities.dart';

void main() {
  group('firstBy', () {
    final posts = [
      Post(
        id: "0",
        message: "Message",
        created: "2019-01-01T13:00:00.000Z",
        subspace: "mooncake",
        owner: "desmos1yhzj9k0sgeq3u0p5a2rq8det5xx9pa3mp7jvtd",
      ),
      Post(
        id: "1",
        message: "Message",
        created: "2019-01-01T13:00:00.000Z",
        subspace: "mooncake",
        owner: "desmos1yhzj9k0sgeq3u0p5a2rq8det5xx9pa3mp7jvtd",
        status: PostStatus(value: PostStatusValue.ERRORED, error: "Error"),
      ),
      Post(
        id: "2",
        message: "Message",
        created: "2019-01-01T13:00:00.000Z",
        subspace: "mooncake",
        owner: "desmos1yhzj9k0sgeq3u0p5a2rq8det5xx9pa3mp7jvtd",
        status: PostStatus(value: PostStatusValue.ERRORED),
      ),
    ];

    test('firstById works properly', () {
      expect(posts.firstBy(id: "0"), posts[0]);
      expect(posts.firstBy(id: "1"), posts[1]);
    });

    test('firstBy message works properly', () {
      expect(posts.firstBy(message: "Message"), posts[0]);
    });

    test('firstBy status works properly', () {
      expect(
        posts.firstBy(status: PostStatus(value: PostStatusValue.ERRORED)),
        posts[2],
      );
    });

    test('firstBy returns null when not found', () {
      expect(posts.firstBy(id: "inexistent"), isNull);
    });
  });

  group('toStringOrEmpty', () {
    test('toStringOrEmpty returns proper value', () {
      expect((-1).toStringOrEmpty(), isNull);
      expect(0.toStringOrEmpty(), isNull);
      expect(1.toStringOrEmpty(), "1");
    });
  });
}
