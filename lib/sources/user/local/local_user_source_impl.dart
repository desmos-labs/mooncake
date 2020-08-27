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
  static const ACCOUNTS = "accounts";

  @visibleForTesting
  static const ACTIVE = "active";

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

  Future<Wallet> _generateWalletHelper(List<String> mnemonic) {
    final walletInfo = _WalletInfo(
      mnemonic,
      _networkInfo,
      _WALLET_DERIVATION_PATH,
    );
    return compute(_deriveWallet, walletInfo);
  }

  @override
  Future<Wallet> saveWallet(String mnemonic) async {
    // Make sure the mnemonic is valid
    if (!bip39.validateMnemonic(mnemonic)) {
      throw Exception("Error while saving wallet: invalid mnemonic.");
    }
    // generate wallet with given mnemonic
    Wallet wallet = await _generateWalletHelper(mnemonic.split(" "));
    // Save it safely
    await _storage.write(key: wallet.bech32Address, value: mnemonic.trim());
    // return a wallet
    return wallet;
  }

  @override
  Future<List<String>> getMnemonic(String address) async {
    final mnemonic = await _storage.read(key: address);
    if (mnemonic == null) {
      // The mnemonic does not exist, no wallet can be created.
      return null;
    }
    return mnemonic.split(" ");
  }

  @override
  Future<Wallet> getWallet(String address) async {
    final mnemonic = await getMnemonic(address);
    if (mnemonic == null) return null;
    return _generateWalletHelper(mnemonic);
  }

  @override
  Future<MooncakeAccount> saveAccount(MooncakeAccount data) async {
    await database.transaction((txn) async {
      final accounts =
          await store.record('${USER_DATA_KEY}.${ACCOUNTS}').get(txn) as List ??
              [];
      List accountsCopy = [...accounts];
      accountsCopy = accountsCopy
          .where((account) =>
              MooncakeAccount.fromJson(account as Map<String, dynamic>)
                  .address !=
              data.address)
          .toList();
      accountsCopy.add(data?.toJson());
      await store.record('${USER_DATA_KEY}.${ACCOUNTS}').put(txn, accountsCopy);
    });
    return data;
  }

  @override
  Future<MooncakeAccount> getActiveAccount() async {
    final record =
        await store.record('${USER_DATA_KEY}.${ACTIVE}').get(database);
    if (record != null) {
      return MooncakeAccount.fromJson(record as Map<String, dynamic>);
    }
    return null;
  }

  @override
  Future<MooncakeAccount> getAccount(String address) async {
    // Try getting the user from the database
    final accounts = await store
            .record('${USER_DATA_KEY}.${ACCOUNTS}')
            .get(database) as List ??
        [];
    final record = accounts.firstWhere(
      (account) =>
          MooncakeAccount.fromJson(account as Map<String, dynamic>).address ==
          address,
      orElse: () => null,
    );
    if (record != null) {
      return MooncakeAccount.fromJson(record as Map<String, dynamic>);
    }

    // If the database does not have the user, see if wallet exist
    final wallet = await getWallet(address);

    // If the address is null return null
    if (wallet == null) {
      return null;
    }

    // Build the user if wallet exists
    final user = MooncakeAccount.local(address);
    await saveAccount(user);

    return user;
  }

  @override
  Future<List<MooncakeAccount>> getAccounts() async {
    var accounts = await store
            .record('${USER_DATA_KEY}.${ACCOUNTS}')
            .get(database) as List ??
        [];
    List<MooncakeAccount> accountsFormatted = [];
    accounts.forEach((account) {
      accountsFormatted
          .add(MooncakeAccount.fromJson(account as Map<String, dynamic>));
    });

    return accountsFormatted;
  }

  @override
  Stream<MooncakeAccount> get accountStream {
    return store
        .query(finder: Finder(filter: Filter.byKey(USER_DATA_KEY)))
        .onSnapshots(database)
        .map((event) => event.isEmpty
            ? null
            : MooncakeAccount.fromJson(
                event.first.value as Map<String, dynamic>,
              ));
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

    return AuthenticationMethod.fromJson(
      jsonDecode(methodString) as Map<String, dynamic>,
    );
  }

  @override
  Future<void> wipeData() async {
    await _storage.deleteAll();
    await store.delete(database);
  }
}
