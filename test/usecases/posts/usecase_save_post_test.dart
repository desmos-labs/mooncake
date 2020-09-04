import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/usecases/usecases.dart';

import '../../mocks/mocks.dart';
import 'common.dart';

void main() {
  PostsRepository repository;
  SavePostUseCase savePostUseCase;

  setUp(() {
    repository = PostsRepositoryMock();
    savePostUseCase = SavePostUseCase(postsRepository: repository);
  });

  group('save works properly', () {
    test('with post without a parent', () async {
      when(repository.savePost(any)).thenAnswer((_) => Future.value(null));

      final post = testPost.copyWith(parentId: '');
      await savePostUseCase.save(post);

      verify(repository.savePost(post)).called(1);
    });

    test('with post with a parent', () async {
      final parent = testPost.copyWith(commentsIds: []);
      when(repository.savePost(any)).thenAnswer((_) => Future.value(null));
      when(repository.getPostById(any)).thenAnswer((_) => Future.value(parent));

      final post = testPost.copyWith(parentId: parent.id);
      await savePostUseCase.save(post);

      verifyInOrder([
        repository.savePost(post),
        repository.getPostById(post.parentId),
        repository.savePost(parent.copyWith(commentsIds: [post.id])),
      ]);
    });
  });
}
