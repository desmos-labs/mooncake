import 'package:meta/meta.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:mooncake/entities/entities.dart';

/// Allows to easily get the information about the currently active account.
class GetActiveAccountUseCase {
  final UserRepository _userRepository;

  GetActiveAccountUseCase({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  /// Returns the currently active account.
  Future<MooncakeAccount> single() {
    return _userRepository.getActiveAccount();
  }

  /// Returns the [Stream] that emits all the [MooncakeAccount] objects
  /// as soon as they are marked as being the currently active account.
  Stream<MooncakeAccount> stream() {
    return _userRepository.activeAccountStream;
  }
}
