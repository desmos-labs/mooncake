import 'package:dwitter/usecases/usecases.dart';
import 'package:meta/meta.dart';

/// Allows to easily log out the user from the application.
class LogoutUseCase {
  final WalletRepository _walletRepository;

  LogoutUseCase({@required WalletRepository walletRepository})
      : assert(walletRepository != null),
        _walletRepository = walletRepository;

  /// Log outs the user from the application.
  Future<void> logout() {
    return _walletRepository.deleteWallet();
  }
}
