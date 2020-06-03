import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'common.dart';

void main() {
  PostsRepository repository;
  DeletePostsUseCase deletePostsUseCase;

  setUp(() {
    repository = PostsRepositoryMock();
    deletePostsUseCase = DeletePostsUseCase(postsRepository: repository);
  });

  test('delete performs the correct calls', () async {
    when(repository.deletePosts()).thenAnswer((_) => Future.value(null));

    await deletePostsUseCase.delete();

    verify(repository.deletePosts()).called(1);
  });
}
