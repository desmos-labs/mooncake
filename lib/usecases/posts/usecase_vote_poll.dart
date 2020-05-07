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

    List<PollAnswer> pollAnswers = List<PollAnswer>()..addAll(post.pollAnswers);
    PollAnswer userAnswer = pollAnswers.firstWhere(
      (element) => element.user.address == userAddress,
      orElse: () => null,
    );

    // The answer does not exist, create it
    if (userAnswer == null) {
      final answer = PollAnswer(
        answers: [option.id],
        user: User.fromAddress(userAddress),
      );
      pollAnswers.add(answer);
    }

    // The answer exists, update it
    if (userAnswer != null) {
      final answers = userAnswer.answers.toSet();
      answers.add(option.id);

      final answer = userAnswer.copyWith(answers: answers.toList());
      pollAnswers = pollAnswers.map((a) {
        return a.user.address == answer.user.address ? answer : a;
      }).toList();
    }

    // Update the post
    post = post.copyWith(pollAnswers: pollAnswers);

    // Store it
    await _postsRepository.savePost(post);

    return post;
  }
}
