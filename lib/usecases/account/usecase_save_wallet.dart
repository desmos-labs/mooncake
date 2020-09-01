import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to properly log in a user.
class SaveWalletUseCase {
  final UserRepository _userRepository;

  SaveWalletUseCase({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  /// Saves the given [mnemonic] into the encrypted storage of the
  /// device as the user wallet.
  Future<Wallet> saveWallet(String mnemonic) async {
    return _userRepository.saveWallet(mnemonic);
  }
}
