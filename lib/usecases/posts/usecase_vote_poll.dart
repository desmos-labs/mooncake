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
    final account = await _userRepository.getActiveAccount();

    final pollAnswers = <PollAnswer>[...post.poll.userAnswers];
    final userAnswer = pollAnswers.firstWhere(
      (element) => element.user.address == account.address,
      orElse: () => null,
    );

    // The answer exists and the post does not allow for multiple answers
    if (userAnswer != null && !post.poll.allowsMultipleAnswers) {
      return post;
    }

    // The answer does not exist, create it
    if (userAnswer == null) {
      final answer = PollAnswer(answer: option.id, user: account.toUser());
      pollAnswers.add(answer);

      // Update the post
      post = post.copyWith(
        poll: post.poll.copyWith(userAnswers: pollAnswers),
        status: PostStatus.storedLocally(account.address),
      );

      // Store it
      await _postsRepository.savePost(post);
    }

    return post;
  }
}
