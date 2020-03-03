import 'dart:convert';

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
  Future<User> getUser(String address) async {
    try {
      // TODO: Implement the user retrieval using GraphQL
      final query = '''
        query AverageTxPerBlock {
          account(where: {address: {_eq: $address}}) {
            num_txs
            total_gas
          }
        }
      ''';

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<void> fundUser(User user) async {
    await http.Client().post(
      _faucetEndpoint,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"address": user.accountData.address}),
    );
  }
}
