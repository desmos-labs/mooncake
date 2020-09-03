import 'package:meta/meta.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to easily refresh the account.
class RefreshAccountUseCase {
  final UserRepository _userRepository;

  RefreshAccountUseCase({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  /// Refreshes the account having the given [address]
  /// an emits any new change using the proper stream.
  Future<void> refresh(String address) {
    return _userRepository.refreshAccount(address);
  }
}
