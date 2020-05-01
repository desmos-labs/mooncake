import 'package:intl/intl.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/sources/sources.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:test/test.dart';

void main() {
  Database database;
  LocalPostsSourceImpl source;

  setUp(() async {
    final factory = databaseFactoryMemory;
    database = await factory.openDatabase(DateTime.now().toIso8601String());
    source = LocalPostsSourceImpl(database: database);
  });

  /// Allows to crete a mock post having the given id.
  Post _createPost(String id) {
    return Post(
      id: id,
      message: id,
      created: DateFormat(Post.DATE_FORMAT).format(DateTime.now()),
      subspace: id,
      owner: User.fromAddress(id),
    );
  }

  /// Stores the given list of posts into the database.
  Future<void> _storePosts(List<Post> posts) async {
    // Filter null elements out
    posts = posts.where((element) => element != null).toList();

    final store = StoreRef.main();
    final keys = posts.map((e) => source.getPostKey(e)).toList();
    final values = posts.map((e) => e.toJson()).toList();
    await store.records(keys).put(database, values);
  }

  test('getPostKey returns correct key', () {
    final post1 = _createPost("1");
    final post2 = _createPost("2");

    expect(source.getPostKey(post1), equals(source.getPostKey(post1)));
    expect(source.getPostKey(post1), isNot(source.getPostKey(post2)));
  });

  test('postsStream emits items correctly upon inserting', () async {
    final posts = [
      _createPost("1").copyWith(
        created: DateFormat(Post.DATE_FORMAT).format(
          DateTime.now().add(Duration(seconds: 1)),
        ),
      ),
      _createPost("2").copyWith(
        created: DateFormat(Post.DATE_FORMAT).format(
          DateTime.now().add(Duration(seconds: 2)),
        ),
      ),
      _createPost("3").copyWith(
        created: DateFormat(Post.DATE_FORMAT).format(
          DateTime.now().add(Duration(seconds: 3)),
        ),
      ),
    ];
    await _storePosts(posts);

    final stream = source.postsStream;
    expectLater(
      stream,
      emitsInOrder([
        [posts[2], posts[1], posts[0]],
      ]),
    );
  });

  test('homePostsStream emits correct events', () async {
    final homePost1 = _createPost("1").copyWith(parentId: "");
    final secondDate = DateTime.now().add(Duration(seconds: 1));
    final homePost2 = _createPost("2").copyWith(
      parentId: "",
      created: DateFormat(Post.DATE_FORMAT).format(secondDate),
    );
    final post1 = _createPost("3").copyWith(parentId: "1");
    final post2 = _createPost("4").copyWith(parentId: "1");
    await _storePosts([homePost1, homePost2, post1, post2]);

    final streamCapped1 = source.homePostsStream(1);
    final streamCapped2 = source.homePostsStream(2);

    expectLater(
      streamCapped1,
      emitsInOrder([
        [homePost2]
      ]),
    );

    expectLater(
      streamCapped2,
      emitsInOrder([
        [homePost2, homePost1],
      ]),
    );
  });

  test('singlePostStream emits correct events', () async {
    final post = _createPost("1");
    await _storePosts([post]);

    final existingStream = source.singlePostStream("1");
    final invalidStream = source.singlePostStream("non-existent");

    expectLater(
      existingStream,
      emitsInOrder([post]),
    );

    expectLater(
      invalidStream,
      emitsInOrder([null]),
    );
  });

  test('getSinglePost returns correct value', () async {
    final post = _createPost("1");
    await _storePosts([post]);

    final stored = await source.getSinglePost("1");
    expect(stored, equals(post));

    final nonExistent = await source.getSinglePost("non-existent");
    expect(nonExistent, isNull);
  });

  test('getPostsByTxHash returns the correct posts', () async {
    final post1 = _createPost("1").copyWith(
        status: PostStatus(
      value: PostStatusValue.SENDING_TX,
      data: "tx_hash_1",
    ));
    final post2 = _createPost("2").copyWith(
        status: PostStatus(
      value: PostStatusValue.TX_SENT,
      data: "tx_hash_2",
    ));
    await _storePosts([post1, post2]);

    final stored1 = await source.getPostsByTxHash("tx_hash_1");
    expect(stored1, isEmpty);

    final stored2 = await source.getPostsByTxHash("tx_hash_2");
    expect(stored2, equals([post2]));
  });

  test('getPostCommentsStream emits correct events', () async {
    final comment = _createPost("2").copyWith(parentId: "1");
    final hiddenComment = _createPost("3").copyWith(
      parentId: "1",
      hidden: true,
    );
    await _storePosts([comment, hiddenComment]);

    final stream = source.getPostCommentsStream("1");
    expectLater(
      stream,
      emitsInOrder([
        [comment],
      ]),
    );
  });

  test('getPostComments return the correct list', () async {
    final comment1 = _createPost("A").copyWith(parentId: "1");
    final hiddenComment = _createPost("B").copyWith(
      parentId: "1",
      hidden: true,
    );
    final secondDate = DateTime.now().add(Duration(seconds: 1));
    final comment2 = _createPost("C").copyWith(
      parentId: "1",
      created: DateFormat(Post.DATE_FORMAT).format(secondDate),
    );
    await _storePosts([comment1, hiddenComment, comment2]);

    final stored = await source.getPostComments("1");
    expect(stored, equals([comment2, comment1]));
  });

  test('getPostsToSync returns the correct list', () async {
    final posts = [
      _createPost("1")
          .copyWith(status: PostStatus(value: PostStatusValue.STORED_LOCALLY)),
      _createPost("2")
          .copyWith(status: PostStatus(value: PostStatusValue.SENDING_TX)),
      _createPost("3")
          .copyWith(status: PostStatus(value: PostStatusValue.TX_SENT)),
      _createPost("4")
          .copyWith(status: PostStatus(value: PostStatusValue.TX_SUCCESSFULL)),
      _createPost("5")
          .copyWith(status: PostStatus(value: PostStatusValue.ERRORED)),
    ];
    await _storePosts(posts);

    final toSync = await source.getPostsToSync();
    expect(toSync, [posts[0], posts[4]]);
  });

  test('savePost stores the post properly', () async {
    final store = StoreRef.main();
    int count = await store.count(database);
    expect(count, isZero);

    final post = _createPost("1");
    await source.savePost(post);
    count = await store.count(database);
    expect(count, equals(1));

    final records = await store.find(database);
    final stored = Post.fromJson(records[0].value);
    expect(stored, equals(post));
  });

  test('mergePosts works properly', () {
    final existingPosts = [
      _createPost("1").copyWith(
        commentsIds: ["2", "3"],
      ),
      null,
      _createPost("10").copyWith(
        commentsIds: ["20"],
        reactions: [
          Reaction(value: ":smile:", user: User.fromAddress("address")),
        ],
      )
    ];

    final newPosts = [
      _createPost("1").copyWith(
        commentsIds: ["5", "9"],
        reactions: [
          Reaction(value: ":grin:", user: User.fromAddress("user")),
        ],
      ),
      _createPost("2"),
      _createPost("10").copyWith(
        commentsIds: ["20", "21"],
        reactions: [
          Reaction(value: ":heart:", user: User.fromAddress("another-user")),
        ],
      ),
    ];

    final merged = source.mergePosts(existingPosts, newPosts);
    expect(newPosts, hasLength(3));

    final expected0 = newPosts[0].copyWith(
      commentsIds: ["5", "9", "2", "3"],
      reactions: [Reaction(value: ":grin:", user: User.fromAddress("user"))],
    );
    expect(merged[0], equals(expected0));

    final expected1 = newPosts[1];
    expect(merged[1], equals(expected1));

    final expected2 = newPosts[2].copyWith(
      commentsIds: ["20", "21"],
      reactions: [
        Reaction(value: ":heart:", user: User.fromAddress("another-user")),
        Reaction(value: ":smile:", user: User.fromAddress("address")),
      ],
    );
    expect(merged[2], equals(expected2));
  });

  test('savePosts saves the data properly with merge false', () async {
    final existingPosts = [
      _createPost("1").copyWith(
        commentsIds: ["2", "3"],
      ),
      null,
      _createPost("10").copyWith(
        commentsIds: ["20"],
        reactions: [
          Reaction(value: ":smile:", user: User.fromAddress("address")),
        ],
      )
    ];
    await _storePosts(existingPosts);

    final newPosts = [
      existingPosts[0].copyWith(
        commentsIds: ["5", "9"],
        reactions: [
          Reaction(value: ":grin:", user: User.fromAddress("user")),
        ],
      ),
      existingPosts[2].copyWith(
        commentsIds: ["20", "21"],
        reactions: [
          Reaction(value: ":heart:", user: User.fromAddress("another-user")),
        ],
      ),
      _createPost("2"),
    ];
    await source.savePosts(newPosts, merge: false);

    final store = StoreRef.main();
    final stored = (await store.find(database))
        .map((e) => Post.fromJson(e.value))
        .toList();
    expect(stored, equals(newPosts));
  });

  test('savePosts saves the data properly with merge true', () async {
    final existingPosts = [
      _createPost("1").copyWith(
        commentsIds: ["2", "3"],
      ),
      null,
      _createPost("10").copyWith(
        commentsIds: ["20"],
        reactions: [
          Reaction(value: ":smile:", user: User.fromAddress("address")),
        ],
      )
    ];
    await _storePosts(existingPosts);

    final newPosts = [
      existingPosts[0].copyWith(
        commentsIds: ["5", "9"],
        reactions: [
          Reaction(value: ":grin:", user: User.fromAddress("user")),
        ],
      ),
      existingPosts[2].copyWith(
        commentsIds: ["20", "21"],
        reactions: [
          Reaction(value: ":heart:", user: User.fromAddress("another-user")),
        ],
      ),
      _createPost("2"),
    ];
    await source.savePosts(newPosts, merge: true);

    final store = StoreRef.main();
    final stored = (await store.find(database))
        .map((e) => Post.fromJson(e.value))
        .toList();

    final expected = [
      newPosts[0].copyWith(
        commentsIds: ["5", "9", "2", "3"],
        reactions: [
          Reaction(value: ":grin:", user: User.fromAddress("user")),
        ],
      ),
      newPosts[1].copyWith(
        commentsIds: ["20", "21"],
        reactions: [
          Reaction(value: ":heart:", user: User.fromAddress("another-user")),
          Reaction(value: ":smile:", user: User.fromAddress("address")),
        ],
      ),
      newPosts[2],
    ];
    expect(stored, equals(expected));
  });
}
