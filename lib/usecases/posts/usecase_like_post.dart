import 'package:desmosdemo/entities/entities.dart';
import 'package:desmosdemo/usecases/usecases.dart';
import 'package:meta/meta.dart';

/// Allows to like a post having a specific id.
class LikePostUseCase {
  final WalletRepository _walletRepository;
  final PostsRepository _postsRepository;

  LikePostUseCase({
    @required WalletRepository walletRepository,
    @required PostsRepository postsRepository,
  })  : assert(walletRepository != null),
        _walletRepository = walletRepository,
        assert(postsRepository != null),
        _postsRepository = postsRepository;

  /// Likes the post having the given [postId] and returns the
  /// updated [Post] object.
  Future<Post> like(String postId) async {
    Post post = await _postsRepository.getPostById(postId);

    if (post == null) {
      // The post does not exist, returns null
      return post;
    }

    // Update the post if the like is not present
    final wallet = await _walletRepository.getWallet();
    if (!post.containsLikeFromUser(wallet.bech32Address)) {
      post = post.copyWith(
        likes: [Like(owner: wallet.bech32Address)] + post.likes,
        status: PostStatus.TO_BE_SYNCED,
      );
      await _postsRepository.savePost(post);
    }

    return post;
  }
}
