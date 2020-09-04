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
        _remoteUserSource = remoteUserSource;

  @visibleForTesting
  Future<MooncakeAccount> updateAndStoreAccountData(String address) async {
    final user = await _localUserSource.getAccount(address);
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
      await updateAndStoreAccountData(wallet.bech32Address);
      return wallet;
    });
  }

  @override
  Future<List<String>> getMnemonic(String address) {
    return _localUserSource.getMnemonic(address);
  }

  Future<Wallet> getWallet(String address) {
    return _localUserSource.getWallet(address);
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
  Future<MooncakeAccount> getAccount(String address) {
    return _localUserSource.getAccount(address);
  }

  @override
  Future<List<MooncakeAccount>> getAccounts() {
    return _localUserSource.getAccounts();
  }

  @override
  Future<void> setActiveAccount(MooncakeAccount account) {
    return _localUserSource.setActiveAccount(account);
  }

  @override
  Future<MooncakeAccount> refreshAccount(String address) {
    return updateAndStoreAccountData(address);
  }

  @override
  Future<MooncakeAccount> getActiveAccount() {
    return _localUserSource.getActiveAccount();
  }

  @override
  Stream<MooncakeAccount> get activeAccountStream {
    return _localUserSource.activeAccountStream;
  }

  @override
  Future<void> fundAccount(MooncakeAccount user) {
    return _remoteUserSource.fundAccount(user);
  }

  @override
  Future<void> saveAuthenticationMethod(
      String address, AuthenticationMethod method) {
    return _localUserSource.saveAuthenticationMethod(address, method);
  }

  @override
  Future<AuthenticationMethod> getAuthenticationMethod(String address) {
    return _localUserSource.getAuthenticationMethod(address);
  }

  @override
  Future<void> deleteData() {
    return _localUserSource.wipeData();
  }

  @override
  Future<void> logout(String account) {
    return _localUserSource.logout(account);
  }
}
