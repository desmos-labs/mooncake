import 'package:meta/meta.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to properly log in a user.
class LoginUseCase {
  final UserRepository _userRepository;

  LoginUseCase({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  /// Saves the given [mnemonic] into the encrypted storage of the
  /// device as the user wallet.
  Future<void> login(String mnemonic) async {
    // Save the wallet
    await _userRepository.saveWallet(mnemonic);

    // Get the account data
    final account = await _userRepository.getAccount();
    if (account == null || account.coins?.isEmpty != false) {
      await _userRepository.fundAccount(account);
    }
  }
}
