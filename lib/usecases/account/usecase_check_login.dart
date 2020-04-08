import 'package:meta/meta.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to easily check whether the user has already logged in into the
/// application or not.
class CheckLoginUseCase {
  final UserRepository _walletRepository;

  CheckLoginUseCase({@required UserRepository walletRepository})
      : assert(walletRepository != null),
        _walletRepository = walletRepository;

  /// Returns `true` iff the user has logged in, `false` otherwise.
  Future<bool> isLoggedIn() async {
    return await _walletRepository.getAccount() != null;
  }
}
