import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to react a post having a specific id.
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

    // Build the reaction object
    final user = await _userRepository.getUserData();
    final reactionObj = Reaction(
      owner: user.accountData.address,
      value: reaction,
    );

    // Add it to the list of reactions if not present and save the new post
    if (!post.reactions.contains(reactionObj)) {
      post = post.copyWith(reactions: post.reactions + [reactionObj]);
      await _postsRepository.savePost(post.copyWith(
        status: PostStatus(value: PostStatusValue.TO_BE_SYNCED),
      ));
    }

    // Remove it from the list of reactions if already present
    else {
      post = post.copyWith(
        reactions: post.reactions.where((r) => r != reactionObj).toList(),
      );
      await _postsRepository.savePost(post.copyWith(
        status: PostStatus(value: PostStatusValue.TO_BE_SYNCED),
      ));
    }

    // Return the (updated) post
    return post;
  }
}
