import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:meta/meta.dart';

/// Allows to react a post having a specific id.
class AddPostReactionUseCase {
  final WalletRepository _walletRepository;
  final PostsRepository _postsRepository;

  AddPostReactionUseCase({
    @required WalletRepository walletRepository,
    @required PostsRepository postsRepository,
  })  : assert(walletRepository != null),
        _walletRepository = walletRepository,
        assert(postsRepository != null),
        _postsRepository = postsRepository;

  /// Likes the post having the given [postId] and returns the
  /// updated [Post] object.
  Future<Post> react(String postId, String reaction) async {
    Post post = await _postsRepository.getPostById(postId);
    if (post == null) {
      return post;
    }

    // Build the reaction object
    final address = await _walletRepository.getAddress();
    final reactionObj = Reaction(owner: address, value: reaction);

    // Add it to the list of reactions if not present and save the new post
    if (!post.reactions.contains(reactionObj)) {
      post = post.copyWith(reactions: post.reactions + [reactionObj]);
      await _postsRepository.savePost(post.copyWith(
        status: PostStatus.TO_BE_SYNCED,
      ));
    }

    // Return the (updated) post
    return post;
  }
}
