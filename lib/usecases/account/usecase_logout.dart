import 'package:meta/meta.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to easily log out the user from the application.
class LogoutUseCase {
  final UserRepository _userRepository;

  LogoutUseCase({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  /// Log outs the user from the application based on the address.
  Future<void> logout(String address) {
    return _userRepository.logout(address);
  }

  /// Log outs all the user from the application.
  Future<void> logoutAll() {
    return _userRepository.deleteData();
  }
}
