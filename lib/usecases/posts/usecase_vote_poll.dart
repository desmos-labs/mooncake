import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows the user to vote for a specific post poll.
class VotePollUseCase {
  final UserRepository _userRepository;
  final PostsRepository _postsRepository;

  VotePollUseCase({
    @required UserRepository userRepository,
    @required PostsRepository postsRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository,
        assert(postsRepository != null),
        _postsRepository = postsRepository;

  /// Updates the given [post] returning it after that the user vote option
  /// has been added after storing it locally.
  /// The option will have the address of the current user, and the value
  /// that is given inside the provided [option].
  Future<Post> vote(Post post, PollOption option) async {
    final account = await _userRepository.getAccount();
    final userAddress = account.cosmosAccount.address;

    PollAnswer userAnswer = post.pollAnswers.firstWhere(
      (element) => element.user.address == userAddress,
      orElse: () => null,
    );

    // The answer does not exist, create it
    if (userAnswer == null) {
      userAnswer = PollAnswer(
        answers: [option.id],
        user: User.fromAddress(userAddress),
      );
    }

    // The answer exists, update it
    if (userAnswer != null) {
      final answers = userAnswer.answers.toSet();
      answers.add(option.id);
      userAnswer = userAnswer.copyWith(answers: answers.toList());
    }

    // Update the answers
    final updatedAnswers = post.pollAnswers.map((answer) {
      return answer.user.address == userAnswer.user.address
          ? userAnswer
          : answer;
    }).toList();

    // Update the post
    post = post.copyWith(pollAnswers: updatedAnswers);

    // Store it
    await _postsRepository.savePost(post);

    return post;
  }
}
