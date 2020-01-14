import 'package:mooncake/usecases/usecases.dart';
import 'package:meta/meta.dart';

/// Allows to easily check whether the user has already logged in into the
/// application or not.
class CheckLoginUseCase {
  final WalletRepository _walletRepository;

  CheckLoginUseCase({@required WalletRepository walletRepository})
      : assert(walletRepository != null),
        _walletRepository = walletRepository;

  /// Returns `true` iff the user has logged in, `false` otherwise.
  Future<bool> isLoggedIn() async {
    return await _walletRepository.getWallet() != null;
  }
}
