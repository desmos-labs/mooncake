import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

import '../../mocks/mocks.dart';
import 'common.dart';

void main() {
  PostsRepository repository;
  GetCommentsUseCase getCommentsUseCase;

  setUp(() {
    repository = PostsRepositoryMock();
    getCommentsUseCase = GetCommentsUseCase(postsRepository: repository);
  });

  test('stream performs the correct calls', () {
    final controller = StreamController<List<Post>>();
    when(repository.getPostCommentsStream(any))
        .thenAnswer((realInvocation) => controller.stream);

    final postId = 'post-id';
    final stream = getCommentsUseCase.stream(postId);
    expectLater(
        stream,
        emitsInOrder([
          [testPost],
          [testPost.copyWith(parentId: '10')],
        ]));

    controller.add([testPost]);
    controller.add([testPost.copyWith(parentId: '10')]);
    controller.close();

    verify(repository.getPostCommentsStream(postId)).called(1);
  });

  test('local performs the correct calls', () async {
    final posts = testPosts;
    when(repository.getPostComments(any))
        .thenAnswer((_) => Future.value(posts));

    final postId = 'post-id';
    final result = await getCommentsUseCase.local(postId);
    expect(result, equals(posts));

    verify(repository.getPostComments(postId)).called(1);
  });

  test('fromRemote performs the correct calls', () async {
    final posts = testPosts;
    when(repository.getPostComments(any, refresh: anyNamed('refresh')))
        .thenAnswer((_) => Future.value(posts));

    final postId = 'post-id';
    final result = await getCommentsUseCase.fromRemote(postId);
    expect(result, equals(posts));

    verify(repository.getPostComments(postId, refresh: true)).called(1);
  });
}
