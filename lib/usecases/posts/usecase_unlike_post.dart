import 'package:desmosdemo/entities/entities.dart';
import 'package:desmosdemo/usecases/usecases.dart';
import 'package:meta/meta.dart';

/// Allows to unlike a post having a given id.
class UnlikePostUseCase {
  final WalletRepository _walletRepository;
  final PostsRepository _postsRepository;

  UnlikePostUseCase({
    @required WalletRepository walletRepository,
    @required PostsRepository postsRepository,
  })  : assert(walletRepository != null),
        _walletRepository = walletRepository,
        assert(postsRepository != null),
        _postsRepository = postsRepository;

  /// Unlikes the post having the given [postId].
  /// Returns the updated post.
  Future<Post> unlike(String postId) async {
    Post post = await _postsRepository.getPostById(postId);

    if (post == null) {
      // The post is null, so return it
      return post;
    }

    // Get the user and the post data
    final wallet = await _walletRepository.getWallet();

    // Remove the like from the user if it exists
    if (post.containsLikeFromUser(wallet.bech32Address)) {
      post = post.copyWith(
        likes: post.likes
            .where((like) => like.owner != wallet.bech32Address)
            .toList(),
        status: PostStatus.TO_BE_SYNCED,
      );
      await _postsRepository.savePost(post);
    }

    return post;
  }
}
