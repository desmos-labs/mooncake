import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to create a new post.
class CreatePostUseCase {
  final UserRepository _userRepository;

  CreatePostUseCase({
    @required UserRepository walletRepository,
  })  : assert(walletRepository != null),
        _userRepository = walletRepository;

  /// Creates a new [Post] object having the given data inside.
  /// Returns the newly created object.
  Future<Post> create({
    @required String message,
    @required bool allowsComments,
    @required String parentId,
    List<PostMedia> medias,
  }) async {
    final account = await _userRepository.getAccount();
    final user = User.fromAddress(account.cosmosAccount.address);
    final date = Post.getDateStringNow();
    return Post(
      id: date,
      created: date,
      parentId: parentId,
      message: message,
      allowsComments: allowsComments,
      medias: medias,
      subspace: Constants.SUBSPACE,
      owner: user,
    );
  }
}
