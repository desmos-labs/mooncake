import 'dart:convert';

import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/sources/sources.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

/// Allows to easily perform chain-related actions such as querying the
/// chain state or sending transactions to it.
class ChainHelper {
  final String _lcdEndpoint;
  final http.Client _httpClient;

  ChainHelper({
    @required String lcdEndpoint,
    @required http.Client httpClient,
  })  : assert(lcdEndpoint != null && lcdEndpoint.isNotEmpty),
        _lcdEndpoint = lcdEndpoint,
        assert(httpClient != null),
        _httpClient = httpClient;

  /// Queries the chain status using the given endpoint and returns
  /// the raw body response.
  Future<Map<String, dynamic>> queryChainRaw(String endpoint) async {
    final url = _lcdEndpoint + endpoint;
    final data = await _httpClient.get(url);
    if (data.statusCode != 200) {
      throw Exception("Expected response code 200, got: ${data.statusCode}");
    }
    return json.decode(data.body);
  }

  /// Utility method to easily query any chain endpoint and
  /// read the response as an [LcdResponse] object instance.
  Future<LcdResponse> queryChain(String endpoint) async {
    final url = _lcdEndpoint + endpoint;
    final data = await _httpClient.get(url);
    if (data.statusCode != 200) {
      throw Exception("Expected response code 200, got: ${data.statusCode}");
    }
    return LcdResponse.fromJson(json.decode(data.body));
  }

  /// Creates, sings and sends a transaction having the given [messages]
  /// and using the given [wallet].
  Future<TransactionResult> sendTx(List<StdMsg> messages, Wallet wallet) async {
    if (messages.isEmpty) {
      // No messages to send, simply return
      return null;
    }

    // Build the tx
    final tx = TxBuilder.buildStdTx(
      stdMsgs: messages,
      fee: StdFee(gas: (200000 * messages.length).toString(), amount: []),
    );

    // Sign the tx
    final signTx = await TxSigner.signStdTx(
      wallet: wallet,
      stdTx: tx,
    );

    print('Sending a new tx to the chain: \n ${jsonEncode(signTx)}');

    // Send the tx to the chain
    final result = await TxSender.broadcastStdTx(
      wallet: wallet,
      stdTx: signTx,
    );

    if (!result.success) {
      throw Exception(result.error.errorMessage);
    }

    return result;
  }
}
