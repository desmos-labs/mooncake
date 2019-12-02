import 'package:desmosdemo/entities/entities.dart';
import 'package:desmosdemo/usecases/posts/posts.dart';
import 'package:desmosdemo/usecases/wallet/wallet.dart';
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
    final date = DateTime.now().toIso8601String();
    final post = Post(
      id: date,
      parentId: parentId,
      message: message,
      created: date,
      lastEdited: null,
      allowsComments: allowsComments,
      externalReference: "",
      owner: wallet.bech32Address,
      likes: [],
      commentsIds: [],
      status: PostStatus.TO_BE_SYNCED,
    );
    await _postsRepository.savePost(post);
    return post;
  }
}
