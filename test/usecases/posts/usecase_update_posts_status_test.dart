import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

import '../../mocks/mocks.dart';
import 'common.dart';

void main() {
  PostsRepository repository;
  UpdatePostsStatusUseCase updatePostsStatusUseCase;

  setUp(() {
    repository = PostsRepositoryMock();
    updatePostsStatusUseCase = UpdatePostsStatusUseCase(
      postsRepository: repository,
    );
  });

  test('update performs the correct calls', () async {
    final posts = testPosts.map((e) {
      return e.copyWith(
        status: PostStatus(value: PostStatusValue.STORED_LOCALLY),
      );
    }).toList();
    when(repository.getPostsByTxHash(any))
        .thenAnswer((_) => Future.value(posts));

    final hash = 'tx-hash';
    final status = PostStatus(value: PostStatusValue.TX_SUCCESSFULL);
    await updatePostsStatusUseCase.update(hash, status);

    final updated = posts.map((e) => e.copyWith(status: status)).toList();
    verifyInOrder([
      repository.getPostsByTxHash(hash),
      repository.savePosts(updated),
    ]);
  });
}
