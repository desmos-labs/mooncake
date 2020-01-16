import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:meta/meta.dart';

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
  Future<String> getAddress() {
    return _walletSource.getAddress();
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
