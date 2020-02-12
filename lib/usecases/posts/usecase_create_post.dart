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
    @required String parentId,
    @required bool allowsComments,
  }) async {
    final address = await _userRepository.getAddress();
    final date = Post.getDateStringNow();
    return Post(
      id: date,
      created: date,
      parentId: parentId,
      message: message,
      allowsComments: allowsComments,
      // This is the app subspace
      subspace: Constants.SUBSPACE,
      owner: address,
    );
  }
}
