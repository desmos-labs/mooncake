import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
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
  Codec.registerMsgType('desmos/MsgCreatePost', MsgCreatePost);
  Codec.registerMsgType('desmos/MsgAddPostReaction', MsgAddPostReaction);
  Codec.registerMsgType('desmos/MsgRemovePostReaction', MsgRemovePostReaction);
  Codec.registerMsgType('desmos/MsgAnswerPoll', MsgAnswerPoll);

  // Account messages
  Codec.registerMsgType('desmos/MsgSaveProfile', MsgSaveProfile);
}

/// Allows to easily perform chain-related actions such as querying the
/// chain state or sending transactions to it.
class ChainSourceImpl extends ChainSource {
  final String _faucetEndpoint;
  final String _lcdEndpoint;

  final http.Client _httpClient;

  ChainSourceImpl({
    @required String lcdEndpoint,
    @required String faucetEndpoint,
    @required http.Client httpClient,
  })  : assert(lcdEndpoint != null && lcdEndpoint.isNotEmpty),
        _lcdEndpoint = lcdEndpoint,
        assert(faucetEndpoint != null && faucetEndpoint.isNotEmpty),
        _faucetEndpoint = faucetEndpoint,
        assert(httpClient != null),
        _httpClient = httpClient {
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
      fee: StdFee(amount: txData.feeAmount, gas: '200000'),
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
      return result == null ? null : LcdResponse.fromJson(result);
    } catch (e) {
      print('LcdResponse parsing exception: $e');
      return null;
    }
  }

  @override
  Future<TransactionResult> sendTx(
    List<StdMsg> messages,
    Wallet wallet, {
    List<StdCoin> fees,
  }) async {
    if (messages.isEmpty) {
      return null;
    }

    // Set the default fees if null
    fees = fees ?? [StdCoin(denom: Constants.FEE_TOKEN, amount: '100000')];

    // Get the account data
    CosmosAccount account;
    try {
      account = await QueryHelper.getAccountData(
        _lcdEndpoint,
        wallet.bech32Address,
      );
    } on Exception catch (e) {
      return TransactionResult.fromException(e);
    }

    // Get the amount of fee tokens the user has
    final balance = account?.coins
            ?.firstWhere(
              (coin) => coin.denom == Constants.FEE_TOKEN,
              orElse: () => null,
            )
            ?.amount ??
        '0';

    // Get the amount of fee token required to be paid
    final requiredFee = fees
            ?.firstWhere(
              (coin) => coin.denom == Constants.FEE_TOKEN,
              orElse: () => null,
            )
            ?.amount ??
        '0';

    if (int.parse(balance) < int.parse(requiredFee)) {
      // If the amount of tokens the user has is less than the one required
      // Get some more funds
      await fundAccount(wallet.bech32Address);
    }

    final data = TxData(messages: messages, wallet: wallet, feeAmount: fees);

    var txResults = await compute(sendTxBackground, data);
    if (!txResults.success) {
      final msg = txResults.error.errorMessage;
      Logger.log('Error while sending transaction to the chain: ${msg}');
    }
    return txResults;
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

  @override
  Future<void> fundAccount(String address) async {
    await _httpClient.post(
      _faucetEndpoint,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'address': address}),
    );
  }
}
