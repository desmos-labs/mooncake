import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/sources/sources.dart';
import 'package:http/http.dart' as http;

/// Implementation of [RemoteUserSource]
class RemoteUserSourceImpl implements RemoteUserSource {
  final ChainHelper _chainHelper;

  RemoteUserSourceImpl({
    @required ChainHelper chainHelper,
  })  : assert(chainHelper != null),
        this._chainHelper = chainHelper;

  @override
  Future<AccountData> getAccountData(String address) async {
    try {
      final endpoint = "/auth/accounts/$address";
      final response = await _chainHelper.queryChain(endpoint);
      final accountData =
          AccountDataResponse.fromJson(response.result).accountData;
      return accountData.address?.isEmpty == true ? null : accountData;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<void> fundAccount(AccountData account) async {
    final endpoint = "https://faucet.desmos.network/airdrop";
    await http.Client().post(
      endpoint,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"address": account.address}),
    );
  }
}
