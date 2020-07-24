import 'package:mooncake/entities/entities.dart';

/// Represents the source that should be used when wanting to work with the
/// blockchain.
abstract class ChainSource {
  /// Returns the LCD endpoint to call.
  String get lcdEndpoint;

  /// Queries the chain status using the given endpoint and returns
  /// the raw body response.
  /// If an exception is thrown, returns `null`.
  Future<Map<String, dynamic>> queryChainRaw(String endpoint);

  /// Utility method to easily query any chain endpoint and
  /// read the response as an [LcdResponse] object instance.
  /// If any exception is thrown, returns `null`.
  Future<LcdResponse> queryChain(String endpoint);

  /// Creates, sings and sends a transaction having the given [messages]
  /// and using the given [wallet].
  /// Optionally, a [fees] can also be specified. If not, a default
  /// 0.1 * 100.000 [Constants.FEE_TOKEN] will be used instead.
  Future<TransactionResult> sendTx(
    List<StdMsg> messages,
    Wallet wallet, {
    List<StdCoin> fees,
  });

  /// Returns the list of transactions that are stored inside the block
  /// having the given [height].
  Future<List<Transaction>> getTxsByHeight(String height);

  /// Allows to sends funds from the faucet to the specified [address].
  Future<void> fundAccount(String address);
}
