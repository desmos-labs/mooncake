import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/posts/posts_repository_impl.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

import '../../mocks/mocks.dart';

class MockLocalPostsSource extends Mock implements LocalPostsSource {}

class MockRemotePostsSource extends Mock implements RemotePostsSource {}

class MockLocalSettingsSource extends Mock implements LocalSettingsSource {}

void main() {
  var localSource = MockLocalPostsSource();
  var remoteSource = MockRemotePostsSource();
  var localSettingsSource = MockLocalSettingsSource();

  PostsRepositoryImpl repository;

  setUp(() {
    repository = PostsRepositoryImpl(
      remoteSource: remoteSource,
      localSource: localSource,
      localSettingsSource: localSettingsSource,
    );
  });

  test('home posts stream returns local one', () {
    final posts = testPosts.take(2).toList();

    final localStream = BehaviorSubject<List<Post>>();
    when(localSource.homePostsStream(any)).thenAnswer((_) => localStream);

    expectLater(repository.getHomePostsStream(10), emits(posts));
    localStream.add(posts);

    localStream.close();
  });

  test('homeEventsStream works properly', () {
    final eventsControllers = StreamController<dynamic>();
    when(remoteSource.homeEventsStream)
        .thenAnswer((_) => eventsControllers.stream);

    final stream = repository.homeEventsStream;
    expectLater(
        stream,
        emitsInOrder([
          [1, 2, 3],
          [4, 5, 6],
        ]));

    eventsControllers.add([1, 2, 3]);
    eventsControllers.add([4, 5, 6]);
    verify(remoteSource.homeEventsStream).called(1);
  });

  test('getHomePosts performs correct calls', () async {
    final start = 20, limit = 50;
    final remotesPosts = testPosts.take(5).toList();
    final localPosts = testPosts.reversed.take(3).toList();
    when(remoteSource.getHomePosts(
            start: anyNamed('start'), limit: anyNamed('limit')))
        .thenAnswer((_) => Future.value(remotesPosts));
    when(localSource.savePosts(any, merge: anyNamed('merge')))
        .thenAnswer((_) => Future.value(null));
    when(localSource.getHomePosts(
            start: anyNamed('start'), limit: anyNamed('limit')))
        .thenAnswer((_) => Future.value(localPosts));

    final result = await repository.getHomePosts(start: start, limit: limit);
    expect(result, equals(localPosts));

    verifyInOrder([
      remoteSource.getHomePosts(start: start, limit: limit),
      localSource.savePosts(remotesPosts, merge: true),
      localSource.getHomePosts(start: start, limit: limit),
    ]);
  });

  test('getPostByIdStream returns correct stream', () {
    final controller = StreamController<Post>();
    when(localSource.singlePostStream(any))
        .thenAnswer((_) => controller.stream);

    final postId = 'post-id';
    final stream = repository.getPostByIdStream(postId);
    expectLater(
        stream,
        emitsInOrder([
          testPost,
          testPost.copyWith(parentId: '100'),
        ]));

    controller.add(testPost);
    controller.add(testPost.copyWith(parentId: '100'));
    verify(localSource.singlePostStream(postId)).called(1);
  });

  group('getPostById performs correct calls', () {
    test('when refresh is set to false', () async {
      final post = testPost;
      when(localSource.getPostById(any)).thenAnswer((_) => Future.value(post));

      final postId = 'post-id';
      final result = await repository.getPostById(postId);
      expect(result, equals(post));

      verify(localSource.getPostById(postId)).called(1);
    });

    test('when refresh is set to true', () async {
      final remotePost = testPost;
      final localPost = testPost.copyWith(parentId: '10');
      when(remoteSource.getPostById(any))
          .thenAnswer((_) => Future.value(remotePost));
      when(localSource.savePost(any)).thenAnswer((_) => Future.value(null));
      when(localSource.getPostById(any))
          .thenAnswer((_) => Future.value(localPost));

      final postId = 'post-id';
      final result = await repository.getPostById(postId, refresh: true);
      expect(result, equals(localPost));

      verifyInOrder([
        remoteSource.getPostById(postId),
        localSource.savePost(remotePost, merge: true),
        localSource.getPostById(postId),
      ]);
    });
  });

  test('getPostByTxHash performs the correct calls', () async {
    final posts = testPosts.take(3).toList();
    when(localSource.getPostsByTxHash(any))
        .thenAnswer((_) => Future.value(posts));

    final txHash = 'tx-hash';
    final result = await repository.getPostsByTxHash(txHash);
    expect(result, equals(posts));

    verify(localSource.getPostsByTxHash(txHash)).called(1);
  });

  test('getPostCommentsStream performs correct calls', () {
    final controller = StreamController<List<Post>>();
    when(localSource.getPostCommentsStream(any))
        .thenAnswer((_) => controller.stream);

    final postId = 'post-id';
    final stream = repository.getPostCommentsStream(postId);
    expectLater(
        stream,
        emitsInOrder([
          [testPost],
          [testPost, testPost],
        ]));

    controller.add([testPost]);
    controller.add([testPost, testPost]);
    controller.close();

    verify(localSource.getPostCommentsStream(postId)).called(1);
  });

  group('getPostComments performs correct calls', () {
    test('when refresh is set to false', () async {
      final posts = [testPost, testPost];
      when(localSource.getPostComments(any))
          .thenAnswer((_) => Future.value(posts));

      final postId = 'post-id';
      final result = await repository.getPostComments(postId);
      expect(result, equals(posts));

      verify(localSource.getPostComments(postId)).called(1);
    });

    test('when refresh is set to true', () async {
      final remotePosts = [testPost];
      final localPosts = [testPost.copyWith(parentId: '10')];
      when(remoteSource.getPostComments(any))
          .thenAnswer((_) => Future.value(remotePosts));
      when(localSource.savePost(any)).thenAnswer((_) => Future.value(null));
      when(localSource.getPostComments(any))
          .thenAnswer((_) => Future.value(localPosts));

      final postId = 'post-id';
      final result = await repository.getPostComments(postId, refresh: true);
      expect(result, equals(localPosts));

      verifyInOrder([
        remoteSource.getPostComments(postId),
        localSource.savePosts(remotePosts),
        localSource.getPostComments(postId),
      ]);
    });
  });

  test('savePost performs correct calls', () async {
    when(localSource.savePost(any)).thenAnswer((_) => Future.value(null));

    final post = testPost;
    await repository.savePost(post);

    verify(localSource.savePost(post)).called(1);
  });

  test('savePosts performs correct calls', () async {
    when(localSource.savePosts(any, merge: anyNamed('merge')))
        .thenAnswer((_) => Future.value(null));

    final posts = [testPost, testPost.copyWith(parentId: '100')];
    await repository.savePosts(posts);

    verify(localSource.savePosts(posts)).called(1);
  });

  group('syncPosts', () {
    test('sync with empty list does nothing', () async {
      final syncPosts = <Post>[];
      when(localSource.getPostsToSync('address'))
          .thenAnswer((_) => Future.value(syncPosts));

      await repository.syncPosts('address');

      verify(localSource.getPostsToSync('address')).called(1);
      verifyNever(localSource.savePosts(any));
    });

    test(
        'success sync updates correctly the statuts and saves to sharedpreferenced',
        () async {
      // --- SETUP
      final syncPosts = testPosts.take(2).toList();
      when(localSource.getPostsToSync('address'))
          .thenAnswer((_) => Future.value(syncPosts));

      final firstUpdate = syncPosts.map((e) {
        return e.copyWith(
          status: PostStatus(value: PostStatusValue.SENDING_TX),
        );
      }).toList();

      final hash = 'hash';
      final result = TransactionResult(hash: hash, success: true, raw: {});
      when(remoteSource.savePosts(any)).thenAnswer((_) => Future.value(result));

      final secondUpdate = syncPosts.map((e) {
        return e.copyWith(
          status: PostStatus(value: PostStatusValue.TX_SENT, data: hash),
        );
      }).toList();

      // --- CALL
      await repository.syncPosts('address');

      // --- VERIFICATION
      verifyInOrder([
        localSource.savePosts(firstUpdate),
        remoteSource.savePosts(firstUpdate),
        localSource.savePosts(secondUpdate),
        localSettingsSource.get(SettingKeys.TX_AMOUNT),
        localSettingsSource.save(SettingKeys.TX_AMOUNT, 2),
      ]);
    });

    test('failed sync updates correcty the status', () async {
      // --- SETUP
      final syncPosts = testPosts.take(2).toList();
      when(localSource.getPostsToSync('address'))
          .thenAnswer((_) => Future.value(syncPosts));

      final firstUpdate = syncPosts.map((e) {
        return e.copyWith(
          status: PostStatus(value: PostStatusValue.SENDING_TX),
        );
      }).toList();

      final hash = 'hash';
      final error = 'error';
      final result = TransactionResult(
        hash: hash,
        success: false,
        raw: {},
        error: TransactionError(errorCode: 0, errorMessage: error),
      );
      when(remoteSource.savePosts(any)).thenAnswer((_) => Future.value(result));

      final secondUpdate = syncPosts.map((e) {
        return e.copyWith(
          status: PostStatus(value: PostStatusValue.ERRORED, data: error),
        );
      }).toList();

      // --- CALL
      await repository.syncPosts('address');

      // --- VERIFICATION
      verifyInOrder([
        localSource.savePosts(firstUpdate),
        remoteSource.savePosts(firstUpdate),
        localSource.savePosts(secondUpdate),
      ]);
      verifyNever(
        localSettingsSource.get(SettingKeys.TX_AMOUNT),
      );
      verifyNever(
        localSettingsSource.save(SettingKeys.TX_AMOUNT, 2),
      );
    });
  });

  group('savePostsAndGetStatus returns the correct result', () {
    test('when the saving is successful', () async {
      final result = TransactionResult(raw: {}, hash: 'tx-hash', success: true);
      when(remoteSource.savePosts(any)).thenAnswer((_) => Future.value(result));

      final posts = [testPost];
      final status = await repository.savePostsRemotelyAndGetStatus(posts);
      expect(
          status,
          equals(PostStatus(
            value: PostStatusValue.TX_SENT,
            data: result.hash,
          )));

      verify(remoteSource.savePosts(posts)).called(1);
    });

    test('when the saving is not successful', () async {
      final result = TransactionResult(
        raw: {},
        hash: 'tx-hash',
        success: false,
        error: TransactionError(errorCode: 0, errorMessage: 'error'),
      );
      when(remoteSource.savePosts(any)).thenAnswer((_) => Future.value(result));

      final posts = [testPost];
      final status = await repository.savePostsRemotelyAndGetStatus(posts);
      expect(
          status,
          equals(PostStatus(
            value: PostStatusValue.ERRORED,
            data: result.error.errorMessage,
          )));
      verify(remoteSource.savePosts(posts)).called(1);
    });
  });

  test('deletePosts performs correct calls', () async {
    when(localSource.deletePosts()).thenAnswer((_) => Future.value(null));

    await repository.deletePosts();

    verify(localSource.deletePosts()).called(1);
  });

  test('deletePost performs correct calls', () async {
    when(localSource.deletePost(any)).thenAnswer((_) => Future.value(null));

    await repository.deletePost(testPost);

    verify(localSource.deletePost(any)).called(1);
  });
}
