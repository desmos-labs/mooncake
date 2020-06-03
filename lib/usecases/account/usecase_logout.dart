import 'package:meta/meta.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to easily log out the user from the application.
class LogoutUseCase {
  final UserRepository _userRepository;

  LogoutUseCase({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  /// Log outs the user from the application.
  Future<void> logout() {
    return _userRepository.deleteData();
  }
}
