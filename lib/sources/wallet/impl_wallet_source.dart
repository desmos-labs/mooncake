import 'package:desmosdemo/repositories/repositories.dart';
import 'package:meta/meta.dart';
import 'package:sacco/sacco.dart';

class WalletSourceImpl extends WalletSource {
  final NetworkInfo _networkInfo;

  WalletSourceImpl({@required NetworkInfo networkInfo})
      : assert(networkInfo != null),
        _networkInfo = networkInfo;

  @override
  Future<Wallet> getWallet() async {
    // TODO: Get this mnemonic from the secure storage
    return Wallet.derive(
      "kitten title artist rare steel since wave gym misery bird defy stage casino color obvious sand valid turtle shy employ clarify solve jar abandon"
          .split(" "),
      _networkInfo,
    );
  }
}
