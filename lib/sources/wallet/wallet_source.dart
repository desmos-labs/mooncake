import 'package:meta/meta.dart';
import 'package:sacco/sacco.dart';

class WalletSource {
  final NetworkInfo _networkInfo;

  WalletSource({@required NetworkInfo networkInfo})
      : assert(networkInfo != null),
        _networkInfo = networkInfo;

  Future<Wallet> getWallet() async {
    // TODO: Get this mnemonic from the secure storage
    return Wallet.derive(
      "kitten title artist rare steel since wave gym misery bird defy stage casino color obvious sand valid turtle shy employ clarify solve jar abandon"
          .split(" "),
      _networkInfo,
    );
  }

  /// Creates, sings and sends a transaction having the given [messages]
  /// and using the given [wallet].
  Future<TransactionResult> sendTx({
    @required List<StdMsg> messages,
    @required Wallet wallet,
  }) async {
    final tx = TxBuilder.buildStdTx(stdMsgs: messages);
    final signedTx = await TxSigner.signStdTx(wallet: wallet, stdTx: tx);
    return TxSender.broadcastStdTx(wallet: wallet, stdTx: signedTx);
  }
}
