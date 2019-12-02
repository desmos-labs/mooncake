import 'package:desmosdemo/repositories/repositories.dart';
import 'package:desmosdemo/usecases/usecases.dart';
import 'package:meta/meta.dart';
import 'package:sacco/sacco.dart';

/// Implementation of [WalletRepository].
class WalletRepositoryImpl extends WalletRepository {
  final WalletSource _walletSource;

  WalletRepositoryImpl({@required WalletSource walletSource})
      : assert(walletSource != null),
        _walletSource = walletSource;

  Future<Wallet> getWallet() {
    return _walletSource.getWallet();
  }
}
