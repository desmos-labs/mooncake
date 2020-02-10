import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/sources/sources.dart';

import 'mocks.dart';

class MockChainHelper extends Mock implements ChainHelper {}

class MockLocalUserSource extends Mock implements LocalUserSource {}

class MockChainEventsConverter extends Mock implements ChainEventsConverter {}

class MockMsgConverter extends Mock implements MsgConverter {}

void main() {
  ChainHelper chainHelper;
  LocalUserSource userSource;
  RemotePostsSourceImpl source;
  ChainEventsConverter eventsConverter;
  MsgConverter msgConverter;

  setUp(() {
    chainHelper = MockChainHelper();
    userSource = MockLocalUserSource();
    eventsConverter = MockChainEventsConverter();
    msgConverter = MockMsgConverter();
    source = RemotePostsSourceImpl(
      rpcEndpoint: "",
      chainHelper: chainHelper,
      userSource: userSource,
      eventsConverter: eventsConverter,
      msgConverter: msgConverter,
    );
  });

  group('parseBlock', () {
    test('returns an empty list when query throws an exception', () async {
      when(chainHelper.queryChainRaw(any)).thenThrow(Exception());

      final result = await source.parseBlock("0");
      expect(result, isEmpty);
    });

    test('returns an empty list if response does not contain txs', () async {
      final response = TxResponse(txs: []);
      when(chainHelper.queryChainRaw(any))
          .thenAnswer((_) => Future.value(response.toJson()));

      final result = await source.parseBlock("1");
      expect(result, isEmpty);
    });

    test('returns the proper data when everything goes ok', () async {
      final txFile = File("test_resources/chain/txs_response_success.json");
      final txContents = txFile.readAsStringSync();
      final tx = Tx.fromJson(jsonDecode(txContents));

      final txResponse = TxResponse(txs: [tx, tx, tx]);
      when(chainHelper.queryChainRaw(any))
          .thenAnswer((_) => Future.value(txResponse.toJson()));

      final txEvents = [
        PostCreatedEvent(
          postId: "0",
          parentId: "0",
          owner: "user",
          height: "0",
        ),
        PostEvent(
          postId: "0",
          height: "0",
        ),
      ];
      when(eventsConverter.convert(any, any)).thenReturn(txEvents);

      final result = await source.parseBlock("1");
      expect(result, hasLength(6));
      expect(
        result.where((e) => e is PostCreatedEvent).toList(),
        hasLength(3),
      );
      expect(
        result.where((e) => !(e is PostCreatedEvent)).toList(),
        hasLength(3),
      );
    });
  });

  group('convertResponse', () {
    test('returns proper data when response is valid', () {
      final file = File("test_resources/posts/posts_list_response.json");
      final json = jsonDecode(file.readAsStringSync());

      final response = RemotePostsSourceImpl.convertResponse(json);
      expect(response.height, "337836");
      expect(response.posts, hasLength(75));
    });

    test('throws an exception when response is not valid', () {
      expect(
        () => RemotePostsSourceImpl.convertResponse(null),
        throwsNoSuchMethodError,
      );
    });
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

  group('getPosts', () {
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

  group('getPostById', () {
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

  group('getPostComments', () {
    test('returns proper data when everything goes ok', () async {
      final parent = testPost.copyWith(commentsIds: ["10", "20", "30"]);
      when(chainHelper.queryChain("/posts/${parent.id}")).thenAnswer((_) =>
          Future.value(LcdResponse(height: "1", result: parent.toJson())));

      final firstComment = testPost.copyWith(message: "First comment");
      when(chainHelper.queryChain("/posts/10")).thenAnswer((_) => Future.value(
          LcdResponse(height: "1", result: firstComment.toJson())));

      final secondComment = testPost.copyWith(message: "Second comment");
      when(chainHelper.queryChain("/posts/20")).thenAnswer((_) => Future.value(
          LcdResponse(height: "1", result: secondComment.toJson())));

      final thirdComment = testPost.copyWith(message: "Third comment");
      when(chainHelper.queryChain("/posts/30")).thenAnswer((_) => Future.value(
          LcdResponse(height: "1", result: thirdComment.toJson())));

      final result = await source.getPostComments(parent.id);
      expect(result, hasLength(3));
      expect(result[0], firstComment);
      expect(result[1], secondComment);
      expect(result[2], thirdComment);
    });
  });

  group('savePost', () {
    final networkInfo = NetworkInfo(bech32Hrp: "desmos", lcdUrl: "localhost");

    test('sends the transactions when everything goes ok', () async {
      final mnemonic = [
        "potato",
        "already",
        "proof",
        "alien",
        "rent",
        "hawk",
        "settle",
        "settle",
        "brush",
        "chase",
        "cage",
        "shell",
        "marriage",
        "drop",
        "foil",
        "garment",
        "solar",
        "join",
        "involve",
        "stock",
        "coffee",
        "toddler",
        "blur",
        "pool",
      ];
      final wallet = Wallet.derive(mnemonic, networkInfo);
      when(userSource.getWallet()).thenAnswer((_) => Future.value(wallet));

      when(chainHelper.queryChain(any)).thenAnswer((_) =>
          Future.value(LcdResponse(height: "0", result: testPost.toJson())));

      final msgs = [
        MsgCreatePost(
          parentId: "1",
          message: "a new message",
          allowsComments: true,
          subspace: "desmos",
          optionalData: {},
          creationDate: "2020-01-01T13:00:00.000Z",
          creator: "user",
        )
      ];
      when(msgConverter.convertPostsToMsg(
        posts: anyNamed("posts"),
        existingPosts: anyNamed("existingPosts"),
        wallet: anyNamed("wallet"),
      )).thenReturn(msgs);

      final txResult = TransactionResult(success: true, hash: "", raw: {});
      when(chainHelper.sendTx(any, any))
          .thenAnswer((_) => Future.value(txResult));

      expect(source.savePosts([]), completes);
    });

    test('propagates exceptions properly', () async {
      final exception = Exception("custom-exception");
      when(userSource.getWallet()).thenThrow(exception);

      expect(source.savePosts([]), throwsA(exception));
    });
  });
}
