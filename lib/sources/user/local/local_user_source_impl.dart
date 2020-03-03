import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

/// Contains the information that needs to be given to derive a [Wallet].
class _WalletInfo {
  final String mnemonic;
  final NetworkInfo networkInfo;
  final String derivationPath;

  _WalletInfo(this.mnemonic, this.networkInfo, this.derivationPath);
}

/// Implementation of [LocalUserSource] that saves the mnemonic into a safe place
/// using the [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)
/// plugin that stores it inside the secure hardware of the device.
class LocalUserSourceImpl extends LocalUserSource {
  static const _WALLET_DERIVATION_PATH = "m/44'/852'/0'/0/0";

  static const _USER_DATA_KEY = "user_data";
  static const _MNEMONIC_KEY = "mnemonic";

  final String _dbName;
  final NetworkInfo _networkInfo;
  final FlutterSecureStorage _storage;

  final _store = StoreRef.main();
  final _userController = BehaviorSubject<User>();

  LocalUserSourceImpl({
    @required String dbName,
    @required NetworkInfo networkInfo,
    @required FlutterSecureStorage secureStorage,
  })  : assert(dbName != null && dbName.isNotEmpty),
        this._dbName = dbName,
        assert(networkInfo != null),
        this._networkInfo = networkInfo,
        assert(secureStorage != null),
        this._storage = secureStorage;

  Future<Database> get _database async {
    final path = await getApplicationDocumentsDirectory();
    await path.create(recursive: true);
    return databaseFactoryIo.openDatabase(join(path.path, this._dbName));
  }

  /// Allows to derive a [Wallet] instance from the given [_WalletInfo] object.
  /// This method is static so that it can be called using the [compute] method
  /// to run it in a different isolate.
  static Wallet _deriveWallet(_WalletInfo info) {
    return Wallet.derive(
      info.mnemonic.split(" "),
      info.networkInfo,
      derivationPath: info.derivationPath,
    );
  }

  @override
  Future<void> saveWallet(String mnemonic) async {
    // Make sure the mnemonic is valid
    if (!bip39.validateMnemonic(mnemonic)) {
      throw Exception("Evver while saving wallet: invalid mnemonic.");
    }

    // Save it safely
    await _storage.write(key: _MNEMONIC_KEY, value: mnemonic.trim());
  }

  @override
  Future<Wallet> getWallet() async {
    final mnemonic = await _storage.read(key: _MNEMONIC_KEY);
    if (mnemonic == null) {
      // The mnemonic does not exist, no wallet can be created.
      return null;
    }

    final walletInfo = _WalletInfo(
      mnemonic,
      _networkInfo,
      _WALLET_DERIVATION_PATH,
    );
    return compute(_deriveWallet, walletInfo);
  }

  @override
  Future<User> getUser() async {
    // Try getting the user from the database
    final database = await this._database;
    final record = await _store.findFirst(database);
    if (record != null) {
      return User.fromJson(record.value);
    }

    // If the database does not have the user, build it from the address
    final wallet = await getWallet();
    final address = wallet?.bech32Address;

    // If the address is null return null
    if (address == null) {
      return null;
    }

    // Build the user from the address and save it
    final user = User.fromAddress(address);
    await saveUser(user);

    return user;
  }

  @override
  Stream<User> get userStream => _userController.stream;


  @override
  Future<void> saveUser(User data) async {
    // Null user, nothing to do
    if (data == null) {
      return;
    }

    final database = await this._database;
    await _store.record(_USER_DATA_KEY).put(database, data.toJson());
    _userController.add(data);
  }

  @override
  Future<void> wipeData() async {
    await _storage.delete(key: _MNEMONIC_KEY);
    await _store.delete(await _database);
  }
}
