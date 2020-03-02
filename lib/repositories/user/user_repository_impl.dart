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

  @override
  Future<User> getUserData() async {
    return _updateAndStoreAccountData().then((_) => _localUserSource.getUser());
  }

  @override
  Stream<User> get userStream => _localUserSource.userStream;

  Future<void> _updateAndStoreAccountData() async {
    final user = await _localUserSource.getUser();
    if (user == null) {
      // No User stored locally, nothing to update
      return;
    }

    // Update the data from the remote source and save it locally
    final data = await _remoteUserSource.getUser(user.accountData.address);
    await _localUserSource.saveUser(data);
  }

  @override
  Future<void> fundUser(User user) {
    return _remoteUserSource.fundUser(user);
  }

  @override
  Future<void> deleteData() {
    return _localUserSource.wipeData();
  }
}
