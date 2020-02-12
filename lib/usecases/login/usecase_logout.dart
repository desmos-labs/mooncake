import 'package:meta/meta.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to easily log out the user from the application.
class LogoutUseCase {
  final UserRepository _walletRepository;

  LogoutUseCase({@required UserRepository walletRepository})
      : assert(walletRepository != null),
        _walletRepository = walletRepository;

  /// Log outs the user from the application.
  Future<void> logout() {
    return _walletRepository.deleteData();
  }
}
