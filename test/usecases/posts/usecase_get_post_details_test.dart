import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

import '../../mocks/mocks.dart';
import 'common.dart';

void main() {
  PostsRepository repository;
  GetPostDetailsUseCase getPostDetailsUseCase;

  setUp(() {
    repository = PostsRepositoryMock();
    getPostDetailsUseCase = GetPostDetailsUseCase(postsRepository: repository);
  });

  test('stream performs correct call', () {
    final controller = StreamController<Post>();
    when(repository.getPostByIdStream(any))
        .thenAnswer((_) => controller.stream);

    final postId = 'post-id';
    final stream = getPostDetailsUseCase.stream(postId);
    expectLater(
        stream,
        emitsInOrder([
          testPost,
          testPost.copyWith(parentId: '10'),
        ]));

    controller.add(testPost);
    controller.add(testPost.copyWith(parentId: '10'));
    controller.close();
  });

  test('local performs correct calls', () async {
    final post = testPost;
    when(repository.getPostById(any)).thenAnswer((_) => Future.value(post));

    final postId = 'post-id';
    final result = await getPostDetailsUseCase.local(postId);
    expect(result, equals(post));
  });

  test('fromRemote performs correct calls', () async {
    final post = testPost;
    when(repository.getPostById(any, refresh: anyNamed('refresh')))
        .thenAnswer((_) => Future.value(post));

    final postId = 'post-id';
    final answer = await getPostDetailsUseCase.fromRemote(postId);
    expect(answer, equals(post));

    verify(repository.getPostById(postId, refresh: true));
  });
}
