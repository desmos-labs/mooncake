import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/entities/posts/post_status.dart';
import 'package:mooncake/usecases/usecases.dart';

import '../../mocks/mocks.dart';
import 'common.dart';

void main() {
  PostsRepository repository;
  UpdatePostUseCase updatePostUseCase;
  setUp(() {
    repository = PostsRepositoryMock();
    updatePostUseCase = UpdatePostUseCase(postsRepository: repository);
  });

  test('does not calls save post', () async {
    when(repository.savePost(any)).thenAnswer((_) => Future.value(null));
    final post = testPost;
    await updatePostUseCase.update(post);

    verifyNever(repository.savePost(any));
  });

  test('calls save post', () async {
    when(repository.savePost(any)).thenAnswer((_) => Future.value(null));
    final post = testPost.copyWith(
      status: PostStatus(value: PostStatusValue.ERRORED),
    );
    await updatePostUseCase.update(post);

    verify(repository.savePost(any)).called(1);
  });
}
