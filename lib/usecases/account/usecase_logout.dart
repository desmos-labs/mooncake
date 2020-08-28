import 'package:meta/meta.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to easily log out the user from the application.
class LogoutUseCase {
  final UserRepository _userRepository;

  LogoutUseCase({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  /// Performs the logout of the account having the given [address].
  /// After logging out the account, all of its data is going to be deleted
  /// from the local storage.
  Future<void> logout(String address) {
    return _userRepository.logout(address);
  }

  /// Log outs all the accounts from the application.
  /// This means deleting all the data of all the accounts from
  /// the local storage.
  Future<void> logoutAll() {
    return _userRepository.deleteData();
  }
}
