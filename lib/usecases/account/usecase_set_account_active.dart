import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to set an account as the current actively used one
class SetAccountActiveUsecase {
  final UserRepository _userRepository;

  SetAccountActiveUsecase({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  /// Sets the given [account] as the current user account.
  Future<void> setActive(MooncakeAccount account) {
    return _userRepository.setActiveAccount(account);
  }
}
