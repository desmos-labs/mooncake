import 'dart:convert';

import 'package:alan/alan.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/sources/sources.dart';

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
  Future<MooncakeAccount> getAccount(String address) async {
    try {
      final cosmosAccount = await QueryHelper.getAccountData(
        _chainHelper.lcdEndpoint,
        address,
      );

      // If no account is found, return null
      if (cosmosAccount == null) {
        return null;
      }

      return MooncakeAccount(
        cosmosAccount: cosmosAccount,
        username: null,
        avatarUrl: null,
      );
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
}
