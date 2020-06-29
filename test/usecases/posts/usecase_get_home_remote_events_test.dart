import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'common.dart';

void main() {
  PostsRepository repository;
  GetHomeEventsUseCase getHomeEventsUseCase;

  setUp(() {
    repository = PostsRepositoryMock();
    getHomeEventsUseCase = GetHomeEventsUseCase(postsRepository: repository);
  });

  test('stream performs the correct calls', () {
    final controller = StreamController<dynamic>();
    when(repository.homeEventsStream).thenAnswer((_) => controller.stream);

    final stream = getHomeEventsUseCase.stream;
    expectLater(
        stream,
        emitsInOrder([
          1,
          2,
          3,
        ]));

    controller.add(1);
    controller.add(2);
    controller.add(3);
    controller.close();

    verify(repository.homeEventsStream).called(1);
  });
}
