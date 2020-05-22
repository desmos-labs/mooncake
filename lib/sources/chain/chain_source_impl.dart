import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/sources/sources.dart';
import 'package:mooncake/utils/logger.dart';

/// Contains all the data needed to perform a transaction.
@visibleForTesting
class TxData extends Equatable {
  final Wallet wallet;

  final List<StdMsg> messages;
  final List<StdCoin> feeAmount;

  TxData({
    @required this.messages,
    @required this.wallet,
    @required this.feeAmount,
  });

  @override
  List<Object> get props => [messages, wallet, feeAmount];
}

void initCodec() {
  // Posts messages
  Codec.registerMsgType("desmos/MsgCreatePost", MsgCreatePost);
  Codec.registerMsgType("desmos/MsgAddPostReaction", MsgAddPostReaction);
  Codec.registerMsgType("desmos/MsgRemovePostReaction", MsgRemovePostReaction);
  Codec.registerMsgType("desmos/MsgAnswerPoll", MsgAnswerPoll);

  // Account messages
  Codec.registerMsgType("desmos/MsgCreateProfile", MsgCreateProfile);
  Codec.registerMsgType("desmos/MsgEditProfile", MsgEditProfile);
}

/// Allows to easily perform chain-related actions such as querying the
/// chain state or sending transactions to it.
class ChainSourceImpl extends ChainSource {
  final String _lcdEndpoint;

  ChainSourceImpl({
    @required String lcdEndpoint,
  })  : assert(lcdEndpoint != null && lcdEndpoint.isNotEmpty),
        _lcdEndpoint = lcdEndpoint {
    // This call is duplicated here due to the fact that [sendTxBackground]
    // will be run on a different isolate and Dart singletons are not
    // cross-threads so this Codec is another instance from the one
    // used inside the sendTxBackground method.
    initCodec();
  }

  @visibleForTesting
  static Future<TransactionResult> sendTxBackground(TxData txData) async {
    // Register custom messages
    // This needs to be done here as this method can run on different isolates.
    // We cannot rely on the initialization done inside the constructor as
    // this Codec instance will not be the same as that one.
    initCodec();
    return TxHelper.sendTx(
      txData.messages,
      txData.wallet,
      fee: StdFee(amount: txData.feeAmount, gas: "200000"),
    );
  }

  @override
  String get lcdEndpoint {
    return _lcdEndpoint;
  }

  @override
  Future<Map<String, dynamic>> queryChainRaw(String endpoint) async {
    try {
      final result = await compute(
        QueryHelper.queryChain,
        _lcdEndpoint + endpoint,
      );
      if (!result.isSuccessful) {
        print(result.error);
        return null;
      }
      return result.value;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<LcdResponse> queryChain(String endpoint) async {
    try {
      final result = await queryChainRaw(endpoint);
      return result == null ? result : LcdResponse.fromJson(result);
    } catch (e) {
      print("LcdResponse parsing exception: $e");
      return null;
    }
  }

  @override
  Future<TransactionResult> sendTx(
    List<StdMsg> messages,
    Wallet wallet, {
    List<StdCoin> feeAmount,
  }) async {
    final data = TxData(
      messages: messages,
      wallet: wallet,
      feeAmount:
          feeAmount ?? [StdCoin(denom: Constants.FEE_TOKEN, amount: "10000")],
    );
    return compute(sendTxBackground, data);
  }

  @override
  Future<List<Transaction>> getTxsByHeight(String height) async {
    try {
      return await QueryHelper.getTxsByHeight(_lcdEndpoint, height);
    } catch (e) {
      Logger.log(e);
      return null;
    }
  }
}
