import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:meta/meta.dart';

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
            accountNumber: "-1",
            sequence: "-1",
            coins: [],
          );
      await _localUserSource.saveData(data);
    }
  }

  @override
  Future<void> saveWallet(String mnemonic) async {
    return _localUserSource
        .saveWallet(mnemonic)
        .then((_) => _updateAndStoreAccountData());
  }

  @override
  Future<AccountData> getAccount() async {
    return _updateAndStoreAccountData()
        .then((_) => _localUserSource.getAccountData());
  }

  @override
  Future<void> deleteData() {
    return _localUserSource.deleteData();
  }
}
