import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to properly log in a user.
class LoginUseCase {
  final UserRepository _userRepository;

  LoginUseCase({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  /// Saves the given [mnemonic] into the encrypted storage of the
  /// device as the user wallet.
  Future<void> login(Wallet wallet, {bool setActive = true}) async {
    // Get the account data
    final user = await _userRepository.refreshAccount(wallet.bech32Address);
    assert(user != null);

    if (setActive) {
      // Make the user active
      await _userRepository.setActiveAccount(user);
    }

    // If needed, send the funds to the user
    if (user.needsFunding) {
      await _userRepository.fundAccount(user);
    }
  }
}
