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
  Future<TransactionResult> sendTx(List<StdMsg> messages, Wallet wallet);

  /// Returns the list of transactions that are stored inside the block
  /// having the given [height].
  Future<List<Transaction>> getTxsByHeight(String height);
}
