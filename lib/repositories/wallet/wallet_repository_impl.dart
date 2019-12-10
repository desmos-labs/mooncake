import 'package:dwitter/repositories/repositories.dart';
import 'package:dwitter/usecases/usecases.dart';
import 'package:meta/meta.dart';
import 'package:sacco/sacco.dart';

/// Implementation of [WalletRepository].
class WalletRepositoryImpl extends WalletRepository {
  final WalletSource _walletSource;

  WalletRepositoryImpl({@required WalletSource walletSource})
      : assert(walletSource != null),
        _walletSource = walletSource;

  @override
  Future<void> saveWallet(String mnemonic) {
    return _walletSource.saveWallet(mnemonic);
  }

  @override
  Future<Wallet> getWallet() {
    return _walletSource.getWallet();
  }

  @override
  Future<void> deleteWallet() {
    return _walletSource.deleteWallet();
  }
}
