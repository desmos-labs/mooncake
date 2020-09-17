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
  VotePollUseCase votePollUseCase;

  setUp(() {
    userRepository = UserRepositoryMock();
    postsRepository = PostsRepositoryMock();
    votePollUseCase = VotePollUseCase(
      postsRepository: postsRepository,
      userRepository: userRepository,
    );
  });

  group('vote works properly', () {
    final account = MooncakeAccount.local('address');
    final post = testPost.copyWith(
      poll: PostPoll(
        question: 'Do you like black?',
        endDate: '2020-05-15T20:00:00.000Z',
        options: [
          PollOption(id: 0, text: 'Yes'),
          PollOption(id: 1, text: 'No'),
        ],
        allowsMultipleAnswers: false,
        allowsAnswerEdits: true,
        userAnswers: [],
      ),
    );

    setUp(() {
      when(userRepository.getActiveAccount())
          .thenAnswer((_) => Future.value(account));
    });

    test('when vote has already been casted', () async {
      final postWithAnswer = post.copyWith(
        poll: post.poll.copyWith(userAnswers: [
          PollAnswer(answer: 1, user: account),
        ]),
      );
      await votePollUseCase.vote(postWithAnswer, post.poll.options[0]);

      verify(userRepository.getActiveAccount());
      verifyNever(postsRepository.savePost(any));
    });

    test('when vote does not yet exists', () async {
      final postWithoutAnswers = post.copyWith(
        poll: post.poll.copyWith(userAnswers: []),
      );
      await votePollUseCase.vote(postWithoutAnswers, post.poll.options[0]);

      verifyInOrder([
        userRepository.getActiveAccount(),
        postsRepository.savePost(post.copyWith(
          poll: post.poll.copyWith(userAnswers: [
            PollAnswer(answer: post.poll.options[0].id, user: account)
          ]),
          status: PostStatus.storedLocally(account.address),
        ))
      ]);
    });
  });
}
