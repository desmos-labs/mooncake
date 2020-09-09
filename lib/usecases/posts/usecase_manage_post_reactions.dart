import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to manage (add/remove) a specific reaction for a post
/// having a given post id.
class ManagePostReactionsUseCase {
  final UserRepository _userRepository;
  final PostsRepository _postsRepository;

  ManagePostReactionsUseCase({
    @required UserRepository userRepository,
    @required PostsRepository postsRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository,
        assert(postsRepository != null),
        _postsRepository = postsRepository;

  /// Likes the post having the given [postId] and returns the
  /// updated [Post] object.
  Future<Post> addOrRemove({
    @required Post post,
    @required String reaction,
  }) async {
    if (reaction == null || reaction.trim().isEmpty) {
      // Reaction is invalid, do nothing
      return post;
    }

    final account = await _userRepository.getActiveAccount();
    final newReactions = post.reactions.removeOrAdd(account, reaction);
    post = post.copyWith(
      reactions: newReactions,
      status: PostStatus.storedLocally(account.address),
    );
    await _postsRepository.savePost(post);
    return post;
  }
}
