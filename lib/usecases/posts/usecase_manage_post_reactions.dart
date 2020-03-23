import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to manage (add/remove) a specific reaction for a post
/// having a given post id.
class ManagePostReactionsUseCase {
  final UserRepository _userRepository;
  final PostsRepository _postsRepository;

  ManagePostReactionsUseCase({
    @required UserRepository walletRepository,
    @required PostsRepository postsRepository,
  })  : assert(walletRepository != null),
        _userRepository = walletRepository,
        assert(postsRepository != null),
        _postsRepository = postsRepository;

  /// Likes the post having the given [postId] and returns the
  /// updated [Post] object.
  Future<Post> addOrRemove({
    @required String postId,
    @required String reaction,
  }) async {
    Post post = await _postsRepository.getPostById(postId);
    if (post == null) {
      return post;
    }

    if (reaction == null || reaction.trim().isEmpty) {
      // Reaction is invalid, do nothing
      return post;
    }

    final account = await _userRepository.getAccount();
    final newReactions = post.reactions.removeOrAdd(account, reaction);
    post = post.copyWith(
      reactions: newReactions,
      status: PostStatus(value: PostStatusValue.STORED_LOCALLY),
    );
    await _postsRepository.savePost(post);

    return post;
  }
}
