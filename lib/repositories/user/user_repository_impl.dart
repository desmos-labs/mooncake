import 'dart:async';

import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Implementation of [UserRepository].
class UserRepositoryImpl extends UserRepository {
  final RemoteUserSource _remoteUserSource;
  final LocalUserSource _localUserSource;

  UserRepositoryImpl({
    @required LocalUserSource localUserSource,
    @required RemoteUserSource remoteUserSource,
  })  : assert(localUserSource != null),
        _localUserSource = localUserSource,
        assert(remoteUserSource != null),
        this._remoteUserSource = remoteUserSource;

  @override
  Future<void> saveWallet(String mnemonic) async {
    return _localUserSource
        .saveWallet(mnemonic)
        .then((_) => _updateAndStoreAccountData());
  }

  @override
  Future<Wallet> getWallet() {
    return _localUserSource.getWallet();
  }

  Future<void> _updateAndStoreAccountData() async {
    final user = await _localUserSource.getAccount();
    if (user == null) {
      // No User stored locally, nothing to update
      return;
    }

    // Update the data from the remote source and save it locally
    final data = await _remoteUserSource.getAccount(user.cosmosAccount.address);
    await _localUserSource.saveAccount(data);
  }

  @override
  Future<MooncakeAccount> getAccount() async {
    return _updateAndStoreAccountData()
        .then((_) => _localUserSource.getAccount());
  }

  @override
  Stream<MooncakeAccount> get accountStream => _localUserSource.accountStream;

  @override
  Future<void> fundAccount(MooncakeAccount user) {
    return _remoteUserSource.fundAccount(user);
  }

  @override
  Future<void> saveAuthenticationMethod(AuthenticationMethod method) {
    return _localUserSource.saveAuthenticationMethod(method);
  }

  @override
  Future<AuthenticationMethod> getAuthenticationMethod() {
    return _localUserSource.getAuthenticationMethod();
  }

  @override
  Future<void> deleteData() {
    return _localUserSource.wipeData();
  }
}
