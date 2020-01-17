import 'package:mooncake/usecases/usecases.dart';
import 'package:meta/meta.dart';

/// Allows to easily retrieve the address of the user's wallet.
class GetAddressUseCase {
  final UserRepository _userRepository;

  GetAddressUseCase({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  /// Returns the address of the user, or `null` if the user
  /// has not yet set a wallet.
  Future<String> get() {
    return _userRepository.getAddress();
  }
}
