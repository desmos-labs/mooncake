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

    final pollAnswers = List<PollAnswer>()..addAll(post.poll.userAnswers);
    final userAnswer = pollAnswers.firstWhere(
      (element) =>
          element.user.address == userAddress && element.answer == option.id,
      orElse: () => null,
    );

    // The answer does not exist, create it
    if (userAnswer == null) {
      final answer = PollAnswer(
        answer: option.id,
        user: User.fromAddress(userAddress),
      );
      pollAnswers.add(answer);

      // Update the post
      final poll = post.poll.copyWith(userAnswers: pollAnswers);
      post = post.copyWith(poll: poll);

      // Store it
      await _postsRepository.savePost(post);
    }

    return post;
  }
}
