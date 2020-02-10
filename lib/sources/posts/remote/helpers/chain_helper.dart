import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/sources/sources.dart';

/// Contains all the data needed to perform a transaction.
@visibleForTesting
class TxData extends Equatable {
  final List<StdMsg> messages;
  final Wallet wallet;

  TxData(this.messages, this.wallet);
  
  @override
  List<Object> get props => [messages, wallet];
}

/// Contains the data returned when performing a chain query.
@visibleForTesting
class RequestResult<T> extends Equatable {
  final T value;
  final String error;

  RequestResult({this.value, this.error})
      : assert(value != null || error != null);

  bool get isSuccessful => error == null;

  @override
  List<Object> get props => [value, error];
}

/// Allows to easily perform chain-related actions such as querying the
/// chain state or sending transactions to it.
class ChainHelper {
  final String _lcdEndpoint;

  ChainHelper({
    @required String lcdEndpoint,
  })  : assert(lcdEndpoint != null && lcdEndpoint.isNotEmpty),
        _lcdEndpoint = lcdEndpoint;

  // The following httpClient and _queryBackground are static as they can
  // be called using the compute method that allows them to run on a different
  // isolate for better performances.
  @visibleForTesting
  static Future<RequestResult<Map<String, dynamic>>> queryChainBackground(
    String url,
  ) async {
    final httpClient = http.Client();
    final data = await httpClient.get(url);
    if (data.statusCode != 200) {
      return RequestResult(
        error: "Call to $url returned status code ${data.statusCode}",
      );
    }

    return RequestResult(value: json.decode(utf8.decode(data.bodyBytes)));
  }

  /// Queries the chain status using the given endpoint and returns
  /// the raw body response.
  /// If an exception is thrown, returns `null`.
  Future<Map<String, dynamic>> queryChainRaw(String endpoint) async {
    final result = await compute(queryChainBackground, _lcdEndpoint + endpoint);
    if (!result.isSuccessful) {
      print(result.error);
      return null;
    }
    return result.value;
  }

  /// Utility method to easily query any chain endpoint and
  /// read the response as an [LcdResponse] object instance.
  /// If any exception is thrown, returns `null`.
  Future<LcdResponse> queryChain(String endpoint) async {
    try {
      final result = await queryChainRaw(endpoint);
      return result == null ? result : LcdResponse.fromJson(result);
    } catch (e) {
      print("LcdResponse parsing exception: $e");
      return null;
    }
  }

  @visibleForTesting
  static Future<TransactionResult> sendTxBackground(TxData data) async {
    final messages = data.messages;
    final wallet = data.wallet;

    if (messages.isEmpty) {
      // No messages to send, simply return
      return null;
    }

    // Register custom messages
    // This needs to be done here as this method can run on different isolates.
    Codec.registerMsgType("desmos/MsgCreatePost", MsgCreatePost);
    Codec.registerMsgType("desmos/MsgAddPostReaction", MsgAddPostReaction);
    Codec.registerMsgType(
      "desmos/MsgRemovePostReaction",
      MsgRemovePostReaction,
    );

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
    final data = TxData(messages, wallet);
    return compute(sendTxBackground, data);
  }
}
