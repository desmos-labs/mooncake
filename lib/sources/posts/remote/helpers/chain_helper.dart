import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/sources/sources.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class _TxData {
  final List<StdMsg> messages;
  final Wallet wallet;

  _TxData(this.messages, this.wallet);
}

/// Allows to easily perform chain-related actions such as querying the
/// chain state or sending transactions to it.
class ChainHelper {
  final String _lcdEndpoint;
  final String _rpcEndpoint;
  final http.Client _httpClient;

  ChainHelper({
    @required String lcdEndpoint,
    @required String rpcEndpoint,
    @required http.Client httpClient,
  })  : assert(lcdEndpoint != null && lcdEndpoint.isNotEmpty),
        _lcdEndpoint = lcdEndpoint,
        assert(rpcEndpoint != null && rpcEndpoint.isNotEmpty),
        this._rpcEndpoint = rpcEndpoint,
        assert(httpClient != null),
        _httpClient = httpClient;

  static Future<Map<String, dynamic>> _queryBackground(String url) async {
    final httpClient = http.Client();
    final data = await httpClient.get(url);
    if (data.statusCode != 200) {
      throw Exception("Call to $url returned status code ${data.statusCode}");
    }
    return json.decode(utf8.decode(data.bodyBytes));
  }

  Future<Map<String, dynamic>> _query(String url) async {
    print("Querying $url");
    return compute(_queryBackground, url);
  }

  /// Queries the RPC to the specified [endpoint].
  Future<Map<String, dynamic>> queryRpc(String endpoint) async {
    final url = _rpcEndpoint + endpoint;
    return _query(url);
  }

  /// Queries the chain status using the given endpoint and returns
  /// the raw body response.
  Future<Map<String, dynamic>> queryChainRaw(String endpoint) async {
    final url = _lcdEndpoint + endpoint;
    return _query(url);
  }

  /// Utility method to easily query any chain endpoint and
  /// read the response as an [LcdResponse] object instance.
  Future<LcdResponse> queryChain(String endpoint) async {
    final url = _lcdEndpoint + endpoint;
    final json = await _query(url);
    return LcdResponse.fromJson(json);
  }

  static Future<TransactionResult> _sendTx(_TxData data) async {
    final messages = data.messages;
    final wallet = data.wallet;

    if (messages.isEmpty) {
      // No messages to send, simply return
      return null;
    }

    // Register custom messages
    Codec.registerMsgType("desmos/MsgCreatePost", MsgCreatePost);
    Codec.registerMsgType("desmos/MsgAddPostReaction", MsgAddPostReaction);
    Codec.registerMsgType("desmos/MsgRemovePostReaction", MsgRemovePostReaction);

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
      final jsonTx = jsonEncode(signTx);
      final error = result.error.errorMessage;
      throw Exception("Error while sending transaction $jsonTx: $error");
    }

    return result;
  }

  /// Creates, sings and sends a transaction having the given [messages]
  /// and using the given [wallet].
  Future<TransactionResult> sendTx(List<StdMsg> messages, Wallet wallet) async {
    final data = _TxData(messages, wallet);
    return compute(_sendTx, data);
  }
}
