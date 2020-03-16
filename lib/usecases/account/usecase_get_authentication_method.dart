import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to get the currently set local authentication method that the
/// user has set.
class GetAuthenticationMethod {
  final UserRepository _userRepository;

  GetAuthenticationMethod({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  /// Returns the currently set local authentication method the user has
  /// previously set. If not method is set, `null` is returned instead.
  Future<AuthenticationMethod> get() {
    return _userRepository.getAuthenticationMethod();
  }
}
