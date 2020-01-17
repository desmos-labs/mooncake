import 'package:bip39/bip39.dart' as bip39;
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

/// Implementation of [LocalUserSource] that saves the mnemonic into a safe place
/// using the [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)
/// plugin that stores it inside the secure hardware of the device.
class LocalUserSourceImpl extends LocalUserSource {
  static const _WALLET_DERIVATION_PATH = "m/44'/852'/0'/0/0";

  static const _ACCOUNT_DATA_KEY = "account_data";
  static const _MNEMONIC_KEY = "mnemonic";

  final String _dbName;
  final NetworkInfo _networkInfo;

  final store = StoreRef.main();
  final FlutterSecureStorage _storage = new FlutterSecureStorage();

  LocalUserSourceImpl({
    @required String dbName,
    @required NetworkInfo networkInfo,
  })  : assert(dbName != null && dbName.isNotEmpty),
        this._dbName = dbName,
        assert(networkInfo != null),
        this._networkInfo = networkInfo;

  Future<Database> get _database async {
    final path = await getApplicationDocumentsDirectory();
    await path.create(recursive: true);
    return databaseFactoryIo.openDatabase(join(path.path, this._dbName));
  }

  @override
  Future<String> getAddress() async {
    final accountData = await getAccountData();
    if (accountData != null) {
      return accountData.address;
    }

    final wallet = await getWallet();
    return wallet.bech32Address;
  }

  @override
  Future<Wallet> getWallet() async {
    final mnemonic = await _storage.read(key: _MNEMONIC_KEY);
    if (mnemonic == null) {
      // The mnemonic does not exist, no wallet can be created.
      return null;
    }

    // Derive the wallet
    return Wallet.derive(
      mnemonic.split(" "),
      _networkInfo,
      derivationPath: _WALLET_DERIVATION_PATH,
    );
  }

  @override
  Future<void> saveWallet(String mnemonic) async {
    // Make sure the mnemonic is valid
    if (!bip39.validateMnemonic(mnemonic)) {
      throw Exception("Invalid mnemonic: $mnemonic");
    }

    // Save it safely
    await _storage.write(key: _MNEMONIC_KEY, value: mnemonic.trim());
  }

  @override
  Future<void> saveData(AccountData data) async {
    final database = await this._database;
    await store.record(_ACCOUNT_DATA_KEY).put(database, data.toJson());
  }

  @override
  Future<AccountData> getAccountData() async {
    final database = await this._database;

    final record = await store.findFirst(database);
    if (record == null) {
      return null;
    }

    return AccountData.fromJson(record.value);
  }

  @override
  Future<void> deleteData() async {
    await _storage.delete(key: _MNEMONIC_KEY);
    await store.delete(await _database);
  }
}
