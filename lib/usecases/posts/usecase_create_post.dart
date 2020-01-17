import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:meta/meta.dart';

/// Allows to create a new post.
class CreatePostUseCase {
  final UserRepository _userRepository;
  final PostsRepository _postsRepository;

  CreatePostUseCase({
    @required UserRepository walletRepository,
    @required PostsRepository postsRepository,
  })  : assert(walletRepository != null),
        _userRepository = walletRepository,
        assert(postsRepository != null),
        _postsRepository = postsRepository;

  /// Creates a new [Post] object having the given data inside.
  /// Returns the newly created object.
  Future<Post> create({
    @required String message,
    @required String parentId,
    @required bool allowsComments,
  }) async {
    final wallet = await _userRepository.getWallet();
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
