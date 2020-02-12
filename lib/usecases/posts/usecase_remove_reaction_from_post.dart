import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to remove a reaction from a post having a given id.
class RemoveReactionFromPostUseCase {
  final UserRepository _walletRepository;
  final PostsRepository _postsRepository;

  RemoveReactionFromPostUseCase({
    @required UserRepository walletRepository,
    @required PostsRepository postsRepository,
  })  : assert(walletRepository != null),
        _walletRepository = walletRepository,
        assert(postsRepository != null),
        _postsRepository = postsRepository;

  /// Unlikes the post having the given [postId].
  /// Returns the updated post.
  Future<Post> remove(String postId, String reaction) async {
    Post post = await _postsRepository.getPostById(postId);
    if (post == null) {
      return post;
    }

    // Build the reaction object
    final address = await _walletRepository.getAddress();
    final reactionObj = Reaction(owner: address, value: reaction);

    // Remove the reaction if present
    final updatedPost = post.copyWith(
      reactions: post.reactions.where((r) => r != reactionObj).toList(),
    );

    // Save the updated post, if the reaction was removed
    if (updatedPost.reactions.length != post.reactions.length) {
      await _postsRepository.savePost(updatedPost.copyWith(
        status: PostStatus(value: PostStatusValue.TO_BE_SYNCED),
      ));
    }

    // Return the (updated) post
    return updatedPost;
  }
}
