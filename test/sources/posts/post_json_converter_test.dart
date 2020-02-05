import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/sources/sources.dart';

class MockChainHelper extends Mock implements ChainHelper {}

class MockLocalUserSource extends Mock implements LocalUserSource {}

void main() {
  final rpcEndpoint = "http://example.com";
  ChainHelper chainHelper;
  LocalUserSource localUserSource;
  RemotePostsSource source;

  setUp(() {
    chainHelper = MockChainHelper();
    localUserSource = MockLocalUserSource();
    source = RemotePostsSourceImpl(
      rpcEndpoint: rpcEndpoint,
      chainHelper: chainHelper,
      userSource: localUserSource,
    );
  });

  /// Sets the [chainHelper] to response with the contents of the file
  /// having the specified [fileName] when [endpoint] is called.
  void setResponse({
    @required String endpoint,
    @required String fileName,
  }) {
    final contents = File(fileName).readAsStringSync();
    when(chainHelper.queryChainRaw(endpoint))
        .thenAnswer((_) => Future.value(jsonDecode(contents)));
  }

  group('Posts', () {
    /// Sets the [chainHelper] to respond to the query for the [pageNumber]
    /// page of posts with the contents of the given [fileName].
    setPageResponse(int pageNumber, String fileName) {
      setResponse(
        endpoint: "/posts?subspace=mooncake&limit=100&page=$pageNumber",
        fileName: "test_resources/posts/$fileName",
      );
    }

    void checkPostsStatus(List<Post> posts) {
      posts.forEach((p) {
        if (p.status.value != PostStatusValue.SYNCED) {
          throw Exception("Post with id ${p.id} has not a synced status");
        }
      });
    }

    test('reading returns empty list correctly', () async {
      setPageResponse(1, "posts_list_response_empty.json");
      final posts = await source.getPosts();
      expect(posts, isEmpty);
    });

    test('reading returns correct list with one page', () async {
      setPageResponse(1, "posts_list_response.json");
      setPageResponse(2, "posts_list_response_empty.json");

      final posts = await source.getPosts();
      expect(posts, hasLength(75));
      expect(posts[4].id, "115");
      checkPostsStatus(posts);
    });

    test('reading returns correct list with two pages', () async {
      setPageResponse(1, "posts_list_response.json");
      setPageResponse(2, "posts_list_response.json");
      setPageResponse(3, "posts_list_response_empty.json");

      final posts = await source.getPosts();
      expect(posts, hasLength(150));
      expect(posts[4].id, "115");
      checkPostsStatus(posts);
    });

    test('reading returns empty list when exception is thrown', () async {
      when(chainHelper.queryChainRaw(any))
          .thenThrow(Exception("Error while reading data"));
      final posts = await source.getPosts();
      expect(posts, isEmpty);
    });
  });

  group('Single post', () {
    test('reading returns null when post does not exist', () async {
      final post = await source.getPostById("999");
      expect(post, isNull);
    });

    test('reading returns proper data when post exists', () async {
      final postId = "56";
      final file = File("test_resources/posts/post_response.json");
      final contents = file.readAsStringSync();
      when(chainHelper.queryChain("/posts/$postId")).thenAnswer(
          (_) => Future.value(LcdResponse.fromJson(jsonDecode(contents))));

      final post = await source.getPostById(postId);
      final expected = Post(
        id: "56",
        parentId: "0",
        message: "Hey, I can see a Dragon around",
        created: "2020-01-14T18:18:56.489519633Z",
        lastEdited: "0001-01-01T00:00:00Z",
        allowsComments: true,
        subspace: "desmos",
        optionalData: {},
        owner: "desmos19u88x09tejnzwpsqnyhgjjglneuxghy6g3da2n",
        reactions: [
          Reaction(
            owner: "desmos16f9wz7yg44pjfhxyn22kycs0qjy778ng877usl",
            value: "🐉",
          ),
          Reaction(
            owner: "desmos14dm0zdemeymhayucp7gchuus3k5m344f3v8nln",
            value: ":star-struck:",
          )
        ],
        commentsIds: ["57"],
        status: PostStatus(value: PostStatusValue.SYNCED),
      );
      expect(post, expected);
    });
  });
}
