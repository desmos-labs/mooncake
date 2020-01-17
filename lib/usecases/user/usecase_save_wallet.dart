import 'package:mooncake/usecases/usecases.dart';
import 'package:meta/meta.dart';

/// Allows to save a mnemonic phrase as the current user's wallet into the
/// encrypted storage of the mobile device the user is using.
class SaveWalletUseCase {
  final UserRepository _walletRepository;

  SaveWalletUseCase({@required UserRepository walletRepository})
      : assert(walletRepository != null),
        _walletRepository = walletRepository;

  /// Saves the given [mnemonic] into the encrypted storage of the
  /// device as the user wallet.
  Future<void> save(String mnemonic) {
    return _walletRepository.saveWallet(mnemonic);
  }
}
