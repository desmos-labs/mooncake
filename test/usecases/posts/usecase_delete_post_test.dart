import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:mooncake/entities/entities.dart';

import '../../mocks/posts.dart';
import 'common.dart';

void main() {
  PostsRepository repository;
  DeletePostUseCase deletePostUseCase;

  setUp(() {
    repository = PostsRepositoryMock();
    deletePostUseCase = DeletePostUseCase(postsRepository: repository);
  });

  test('delete performs the correct calls', () async {
    when(repository.deletePosts()).thenAnswer((_) => Future.value(null));
    await deletePostUseCase.delete(testPost);
    verifyNever(repository.deletePost(any));

    await deletePostUseCase.delete(testPost.copyWith(
      status: PostStatus(value: PostStatusValue.ERRORED),
    ));

    verify(repository.deletePost(any)).called(1);
  });
}
