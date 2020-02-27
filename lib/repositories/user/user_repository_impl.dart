import 'dart:async';

import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:rxdart/rxdart.dart';

/// Implementation of [UserRepository].
class UserRepositoryImpl extends UserRepository {
  final RemoteUserSource _remoteUserSource;
  final LocalUserSource _localUserSource;

  final StreamController _accountController = BehaviorSubject<AccountData>();

  UserRepositoryImpl({
    @required LocalUserSource localUserSource,
    @required RemoteUserSource remoteUserSource,
  })  : assert(localUserSource != null),
        _localUserSource = localUserSource,
        assert(remoteUserSource != null),
        this._remoteUserSource = remoteUserSource;

  @override
  Future<User> getUser() async {
    return User(
      address: "desmos12v62d963xs2sqfugdtrg4a8myekvj3sf473cfv",
      username: "Desmos",
      avatarUrl:
          "https://pbs.twimg.com/profile_images/1206578012549980162/6L485PKE_400x400.jpg",
    );

    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<String> getAddress() {
    return _localUserSource.getAddress();
  }

  @override
  Future<Wallet> getWallet() {
    return _localUserSource.getWallet();
  }

  Future<void> _updateAndStoreAccountData() async {
    final address = await _localUserSource.getAddress();
    if (address != null) {
      final data = (await _remoteUserSource.getAccountData(address)) ??
          AccountData(
            address: address,
            accountNumber: 0,
            sequence: 0,
            coins: [],
          );
      await _localUserSource.saveAccountData(data);
      _accountController.add(data);
    }
  }

  @override
  Future<void> saveWallet(String mnemonic) async {
    return _localUserSource
        .saveWallet(mnemonic)
        .then((_) => _updateAndStoreAccountData());
  }

  @override
  Stream<AccountData> observeAccount() => _accountController.stream;

  @override
  Future<AccountData> getAccount() async {
    return _updateAndStoreAccountData()
        .then((_) => _localUserSource.getAccountData());
  }

  @override
  Future<void> fundAccount(AccountData account) {
    return _remoteUserSource.fundAccount(account);
  }

  @override
  Future<void> deleteData() {
    return _localUserSource.wipeData();
  }
}
