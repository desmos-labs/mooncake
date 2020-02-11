import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/sources/sources.dart';
import 'package:http/http.dart' as http;

/// Implementation of [RemoteUserSource]
class RemoteUserSourceImpl implements RemoteUserSource {
  final String _faucetEndpoint;
  final ChainHelper _chainHelper;

  RemoteUserSourceImpl({
    @required ChainHelper chainHelper,
    @required String faucetEndpoint,
  })  : assert(chainHelper != null),
        this._chainHelper = chainHelper,
        assert(faucetEndpoint != null),
        _faucetEndpoint = faucetEndpoint;

  @override
  Future<AccountData> getAccountData(String address) async {
    try {
      final endpoint = "/auth/accounts/$address";
      final response = await _chainHelper.queryChain(endpoint);
      final result = response.result;
      if (result.isEmpty) {
        throw Exception("Empty account result");
      }

      final accountData = AccountDataResponse.fromJson(result).accountData;
      return accountData.address?.isEmpty == true ? null : accountData;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<void> fundAccount(AccountData account) async {
    await http.Client().post(
      _faucetEndpoint,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"address": account.address}),
    );
  }
}
