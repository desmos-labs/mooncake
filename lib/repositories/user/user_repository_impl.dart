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

  @visibleForTesting
  Future<MooncakeAccount> updateAndStoreAccountData() async {
    final user = await _localUserSource.getAccount();
    if (user == null) {
      // No User stored locally, nothing to update
      return null;
    }

    // Update the data from the remote source and save it locally
    final data = await _remoteUserSource.getAccount(user.cosmosAccount.address);
    return data == null ? user : await _localUserSource.saveAccount(data);
  }

  @override
  Future<Wallet> saveWallet(String mnemonic) async {
    return _localUserSource.saveWallet(mnemonic).then((Wallet wallet) async {
      await updateAndStoreAccountData();
      return wallet;
    });
  }

  @override
  Future<List<String>> getMnemonic() {
    return _localUserSource.getMnemonic();
  }

  @override
  Future<Wallet> getWallet() {
    return _localUserSource.getWallet();
  }

  @override
  Future<AccountSaveResult> saveAccount(
    MooncakeAccount account, {
    bool syncRemote = false,
  }) async {
    if (syncRemote) {
      final remoteResult = await _remoteUserSource.saveAccount(account);
      if (!remoteResult.success) {
        return remoteResult;
      }
    }

    await _localUserSource.saveAccount(account);
    return AccountSaveResult.success();
  }

  @override
  Future<MooncakeAccount> getAccount() {
    return _localUserSource.getAccount();
  }

  @override
  Future<MooncakeAccount> refreshAccount() {
    return updateAndStoreAccountData();
  }

  @override
  Stream<MooncakeAccount> get accountStream {
    return _localUserSource.accountStream;
  }

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
