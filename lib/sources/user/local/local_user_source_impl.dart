import 'dart:convert';

import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:sembast/sembast.dart';

/// Contains the information that needs to be given to derive a [Wallet].
class _WalletInfo {
  final List<String> mnemonic;
  final NetworkInfo networkInfo;
  final String derivationPath;

  _WalletInfo(this.mnemonic, this.networkInfo, this.derivationPath);
}

/// Implementation of [LocalUserSource] that saves the mnemonic into a safe place
/// using the [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)
/// plugin that stores it inside the secure hardware of the device.
class LocalUserSourceImpl extends LocalUserSource {
  static const _WALLET_DERIVATION_PATH = "m/44'/852'/0'/0/0";

  @visibleForTesting
  static const AUTHENTICATION_KEY = "authentication";

  @visibleForTesting
  static const USER_DATA_KEY = "user_data";

  @visibleForTesting
  static const MNEMONIC_KEY = "mnemonic";

  final Database database;
  final NetworkInfo _networkInfo;
  final FlutterSecureStorage _storage;

  final store = StoreRef.main();

  LocalUserSourceImpl({
    @required Database database,
    @required NetworkInfo networkInfo,
    @required FlutterSecureStorage secureStorage,
  })  : assert(database != null),
        database = database,
        assert(networkInfo != null),
        this._networkInfo = networkInfo,
        assert(secureStorage != null),
        this._storage = secureStorage;

  /// Allows to derive a [Wallet] instance from the given [_WalletInfo] object.
  /// This method is static so that it can be called using the [compute] method
  /// to run it in a different isolate.
  static Wallet _deriveWallet(_WalletInfo info) {
    return Wallet.derive(
      info.mnemonic,
      info.networkInfo,
      derivationPath: info.derivationPath,
    );
  }

  @override
  Future<void> saveWallet(String mnemonic) async {
    // Make sure the mnemonic is valid
    if (!bip39.validateMnemonic(mnemonic)) {
      throw Exception("Error while saving wallet: invalid mnemonic.");
    }

    // Save it safely
    await _storage.write(key: MNEMONIC_KEY, value: mnemonic.trim());
  }

  @override
  Future<List<String>> getMnemonic() async {
    final mnemonic = await _storage.read(key: MNEMONIC_KEY);
    if (mnemonic == null) {
      // The mnemonic does not exist, no wallet can be created.
      return null;
    }
    return mnemonic.split(" ");
  }

  @override
  Future<Wallet> getWallet() async {
    final mnemonic = await getMnemonic();
    if (mnemonic == null) return null;

    final walletInfo = _WalletInfo(
      mnemonic,
      _networkInfo,
      _WALLET_DERIVATION_PATH,
    );
    return compute(_deriveWallet, walletInfo);
  }

  @override
  Future<void> saveAccount(MooncakeAccount data) async {
    await database.transaction((txn) async {
      await store.record(USER_DATA_KEY).put(txn, data?.toJson());
    });
  }

  @override
  Future<MooncakeAccount> getAccount() async {
    // Try getting the user from the database
    final record = await store.record(USER_DATA_KEY).get(database);
    if (record != null) {
      return MooncakeAccount.fromJson(record);
    }

    // If the database does not have the user, build it from the address
    final wallet = await getWallet();
    final address = wallet?.bech32Address;

    // If the address is null return null
    if (address == null) {
      return null;
    }

    // Build the user from the address and save it
    final user = MooncakeAccount.local(address);
    await saveAccount(user);

    return user;
  }

  @override
  Stream<MooncakeAccount> get accountStream {
    return store
        .stream(database, filter: Filter.byKey(USER_DATA_KEY))
        .map((event) => MooncakeAccount.fromJson(event.value));
  }

  @override
  Future<void> saveAuthenticationMethod(AuthenticationMethod method) async {
    final methodString = jsonEncode(method.toJson());
    await _storage.write(key: AUTHENTICATION_KEY, value: methodString);
  }

  @override
  Future<AuthenticationMethod> getAuthenticationMethod() async {
    final methodString = await _storage.read(key: AUTHENTICATION_KEY);
    if (methodString == null) {
      return null;
    }

    return AuthenticationMethod.fromJson(jsonDecode(methodString));
  }

  @override
  Future<void> wipeData() async {
    await _storage.deleteAll();
    await store.delete(database);
  }
}
