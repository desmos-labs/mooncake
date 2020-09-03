import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

import '../../mocks/mocks.dart';
import 'common.dart';

void main() {
  PostsRepository repository;
  GetHomePostsUseCase getHomePostsUseCase;

  setUp(() {
    repository = PostsRepositoryMock();
    getHomePostsUseCase = GetHomePostsUseCase(postsRepository: repository);
  });

  test('stream performs correct calls', () {
    final controller = StreamController<List<Post>>();
    when(repository.getHomePostsStream(any))
        .thenAnswer((_) => controller.stream);

    final limit = 10;
    final stream = getHomePostsUseCase.stream(limit);
    expectLater(
        stream,
        emitsInOrder([
          [testPost],
        ]));

    controller.add([testPost]);
    controller.close();

    verify(repository.getHomePostsStream(limit)).called(1);
  });

  test('get performs correct calls', () async {
    final posts = testPosts;
    when(repository.getHomePosts(
      start: anyNamed('start'),
      limit: anyNamed('limit'),
    )).thenAnswer((_) => Future.value(posts));

    final start = 10;
    final limit = 10;
    final result = await getHomePostsUseCase.get(start: start, limit: limit);
    expect(result, equals(posts));

    verify(repository.getHomePosts(start: start, limit: limit)).called(1);
  });
}
