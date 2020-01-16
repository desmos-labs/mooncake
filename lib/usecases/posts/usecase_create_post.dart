import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/posts/posts.dart';
import 'package:mooncake/usecases/wallet/wallet.dart';
import 'package:meta/meta.dart';

/// Allows to create a new post.
class CreatePostUseCase {
  final WalletRepository _walletRepository;
  final PostsRepository _postsRepository;

  CreatePostUseCase({
    @required WalletRepository walletRepository,
    @required PostsRepository postsRepository,
  })  : assert(walletRepository != null),
        _walletRepository = walletRepository,
        assert(postsRepository != null),
        _postsRepository = postsRepository;

  /// Creates a new [Post] object having the given data inside.
  /// Returns the newly created object.
  Future<Post> create(
    String message, {
    String parentId,
    bool allowsComments = false,
  }) async {
    final wallet = await _walletRepository.getWallet();
    final date = Post.getDateStringNow();

    final post = Post(
      id: date,
      created: date,
      parentId: parentId,
      message: message,
      allowsComments: allowsComments,
      // This is the app subspace
      subspace: "mooncake",
      owner: wallet.bech32Address,
    );
    await _postsRepository.savePost(post);
    return post;
  }
}
