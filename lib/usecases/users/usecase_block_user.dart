import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to block a specified user.
class BlockUserUseCase {
  final UsersRepository _usersRepository;

  BlockUserUseCase({
    @required UsersRepository usersRepository,
  })  : assert(usersRepository != null),
        _usersRepository = usersRepository;

  /// Block the given [user].
  Future<void> block(User user) {
    return _usersRepository.blockUser(user);
  }
}
