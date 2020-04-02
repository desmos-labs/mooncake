import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/posts/posts_repository_impl.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:rxdart/rxdart.dart';

import '../../mocks/mocks.dart';

class LocalSource extends Mock implements LocalPostsSource {}

class RemoteSource extends Mock implements RemotePostsSource {}

void main() {
  LocalSource localSource = LocalSource();
  RemoteSource remoteSource = RemoteSource();
  PostsRepositoryImpl repository;

  setUp(() {
    repository = PostsRepositoryImpl(
      remoteSource: remoteSource,
      localSource: localSource,
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

  group('syncPosts', () {
    test('sync with empty list does nothing', () async {
      final syncPosts = List<Post>();
      when(localSource.getPostsToSync())
          .thenAnswer((_) => Future.value(syncPosts));

      await repository.syncPosts();

      verify(localSource.getPostsToSync()).called(1);
      verifyNever(localSource.savePosts(any));
    });

    test('success sync updates correctly the statuts', () async {
      // --- SETUP
      final syncPosts = testPosts.take(2).toList();
      when(localSource.getPostsToSync())
          .thenAnswer((_) => Future.value(syncPosts));

      final firstUpdate = syncPosts.map((e) {
        return e.copyWith(
          status: PostStatus(value: PostStatusValue.SENDING_TX),
        );
      }).toList();

      final hash = "hash";
      final result = TransactionResult(hash: hash, success: true, raw: {});
      when(remoteSource.savePosts(any)).thenAnswer((_) => Future.value(result));

      final secondUpdate = syncPosts.map((e) {
        return e.copyWith(
          status: PostStatus(value: PostStatusValue.TX_SENT, data: hash),
        );
      }).toList();

      // --- CALL
      await repository.syncPosts();

      // --- VERIFICATION
      verifyInOrder([
        localSource.savePosts(firstUpdate),
        remoteSource.savePosts(firstUpdate),
        localSource.savePosts(secondUpdate),
      ]);
    });

    test('failed sync updates correcty the status', () async {
      // --- SETUP
      final syncPosts = testPosts.take(2).toList();
      when(localSource.getPostsToSync())
          .thenAnswer((_) => Future.value(syncPosts));

      final firstUpdate = syncPosts.map((e) {
        return e.copyWith(
          status: PostStatus(value: PostStatusValue.SENDING_TX),
        );
      }).toList();

      final hash = "hash";
      final error = "error";
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
      await repository.syncPosts();

      // --- VERIFICATION
      verifyInOrder([
        localSource.savePosts(firstUpdate),
        remoteSource.savePosts(firstUpdate),
        localSource.savePosts(secondUpdate),
      ]);
    });

    test('sync throwing exception updates correcty the status', () async {
      // --- SETUP
      final syncPosts = testPosts.take(2).toList();
      when(localSource.getPostsToSync())
          .thenAnswer((_) => Future.value(syncPosts));

      final firstUpdate = syncPosts.map((e) {
        return e.copyWith(
          status: PostStatus(value: PostStatusValue.SENDING_TX),
        );
      }).toList();

      final error = Exception("error");
      when(remoteSource.savePosts(any)).thenThrow(error);

      final secondUpdate = syncPosts.map((e) {
        return e.copyWith(
          status: PostStatus(
            value: PostStatusValue.ERRORED,
            data: error.toString(),
          ),
        );
      }).toList();

      // --- CALL
      await repository.syncPosts();

      // --- VERIFICATION
      verifyInOrder([
        localSource.savePosts(firstUpdate),
        remoteSource.savePosts(firstUpdate),
        localSource.savePosts(secondUpdate),
      ]);
    });
  });
}
