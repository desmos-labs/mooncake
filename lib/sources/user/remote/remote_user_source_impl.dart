import 'dart:convert';
import 'dart:io';

import 'package:alan/alan.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/sources/sources.dart';

import 'helpers/export.dart';

/// Implementation of [RemoteUserSource]
class RemoteUserSourceImpl implements RemoteUserSource {
  final String _faucetEndpoint;
  final GraphQLClient _gqlClient;
  final UserMsgConverter _msgConverter;

  final ChainSource _chainSource;
  final LocalUserSource _userSource;
  final RemoteMediasSource _remoteMediasSource;

  RemoteUserSourceImpl({
    @required String faucetEndpoint,
    @required GraphQLClient graphQLClient,
    @required UserMsgConverter msgConverter,
    @required ChainSource chainHelper,
    @required LocalUserSource userSource,
    @required RemoteMediasSource remoteMediasSource,
  })  : assert(chainHelper != null),
        this._chainSource = chainHelper,
        assert(graphQLClient != null),
        _gqlClient = graphQLClient,
        assert(faucetEndpoint != null),
        _faucetEndpoint = faucetEndpoint,
        assert(msgConverter != null),
        _msgConverter = msgConverter,
        assert(userSource != null),
        _userSource = userSource,
        assert(remoteMediasSource != null),
        _remoteMediasSource = remoteMediasSource;

  @override
  Future<MooncakeAccount> getAccount(String address) async {
    try {
      // Get the chain data
      final cosmosAccount = await QueryHelper.getAccountData(
        _chainSource.lcdEndpoint,
        address,
      );

      // If no account is found, return null
      if (cosmosAccount == null) {
        return null;
      }

      // Get the other data
      final user = await GqlUsersHelper.getUserByAddress(_gqlClient, address);
      return MooncakeAccount.fromUser(cosmosAccount, user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<void> fundAccount(MooncakeAccount user) async {
    await http.Client().post(
      _faucetEndpoint,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"address": user.cosmosAccount.address}),
    );
  }

  @override
  Future<void> saveAccount(MooncakeAccount account) async {
    final wallet = await _userSource.getWallet();
    final remoteAccount = await getAccount(account.address);

    // Upload the images to IPFS if they need to be uploaded
    final profilePicFile = File(account.profilePicUri ?? "");
    if (profilePicFile.existsSync()) {
      final profilePic = await _remoteMediasSource.uploadMedia(profilePicFile);
      account = account.copyWith(profilePicUri: profilePic);
    }

    final coverPicFile = File(account.coverPicUri ?? "");
    if (coverPicFile.existsSync()) {
      final coverPic = await _remoteMediasSource.uploadMedia(coverPicFile);
      account = account.copyWith(coverPicUrl: coverPic);
    }

    // Create the transaction message
    final msg = _msgConverter.toUserMsg(account, remoteAccount);

    // Send the message to the chain
    final feeAmount = [StdCoin(amount: "200000", denom: Constants.FEE_TOKEN)];
    return _chainSource.sendTx([msg], wallet, feeAmount: feeAmount);
  }
}
