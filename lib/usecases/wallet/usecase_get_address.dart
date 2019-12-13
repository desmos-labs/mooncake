import 'package:dwitter/usecases/usecases.dart';
import 'package:meta/meta.dart';

/// Allows to easily retrieve the address of the user's wallet.
class GetAddressUseCase {
  final WalletRepository _walletRepository;

  GetAddressUseCase({@required WalletRepository walletRepository})
      : assert(walletRepository != null),
        _walletRepository = walletRepository;

  /// Returns the address of the user, or `null` if the user
  /// has not yet set a wallet.
  Future<String> get() {
    return _walletRepository.getAddress();
  }
}
