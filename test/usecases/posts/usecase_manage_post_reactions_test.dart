import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/account/export.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

import '../../mocks/mocks.dart';
import 'common.dart';

class UserRepositoryMock extends Mock implements UserRepository {}

void main() {
  UserRepository userRepository;
  PostsRepository postsRepository;
  ManagePostReactionsUseCase managePostReactionsUseCase;

  setUp(() {
    userRepository = UserRepositoryMock();
    postsRepository = PostsRepositoryMock();
    managePostReactionsUseCase = ManagePostReactionsUseCase(
      postsRepository: postsRepository,
      userRepository: userRepository,
    );
  });

  test('addOrRemove adds correctly a missing reaction', () async {
    final account = MooncakeAccount.local('address');
    when(userRepository.getActiveAccount())
        .thenAnswer((_) => Future.value(account));
    when(postsRepository.savePost(any)).thenAnswer((_) => Future.value(null));

    final post = testPost.copyWith(reactions: []);
    final result = await managePostReactionsUseCase.addOrRemove(
      post: post,
      reaction: '😊',
    );

    final expected = post.copyWith(
      status: PostStatus.storedLocally(account.address),
      reactions: [Reaction.fromValue('😊', account.toUser())],
    );
    expect(result, equals(expected));

    verifyInOrder([
      userRepository.getActiveAccount(),
      postsRepository.savePost(expected),
    ]);
  });
}
