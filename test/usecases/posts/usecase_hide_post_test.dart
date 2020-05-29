import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/usecases/usecases.dart';

import '../../mocks/mocks.dart';
import 'common.dart';

void main() {
  PostsRepository repository;
  HidePostUseCase hidePostUseCase;

  setUp(() {
    repository = PostsRepositoryMock();
    hidePostUseCase = HidePostUseCase(postsRepository: repository);
  });

  test('hide performs correct calls', () async {
    when(repository.savePost(any)).thenAnswer((_) => Future.value(null));

    final post = testPost.copyWith(hidden: false);

    final result = await hidePostUseCase.hide(post);
    final hiddenPost = post.copyWith(hidden: true);
    expect(result, equals(hiddenPost));

    verify(repository.savePost(hiddenPost)).called(1);
  });
}
