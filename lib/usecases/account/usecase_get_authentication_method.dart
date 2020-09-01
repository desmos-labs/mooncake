import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to get the currently set local authentication method that the
/// user has set.
class GetAuthenticationMethodUseCase {
  final UserRepository _userRepository;

  GetAuthenticationMethodUseCase({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  /// Returns the currently set local authentication method the user has
  /// previously set for the account having the given [address].
  /// If no method is set, `null` is returned instead.
  Future<AuthenticationMethod> get(String address) {
    return _userRepository.getAuthenticationMethod(address);
  }
}
