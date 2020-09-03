import 'dart:convert';

import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  static const AUTHENTICATION_KEY = 'authentication';

  @visibleForTesting
  static const ACCOUNTS_LIST_KEY = 'accounts';

  @visibleForTesting
  static const ACTIVE_ACCOUNT_KEY = 'active_account';

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
        _networkInfo = networkInfo,
        assert(secureStorage != null),
        _storage = secureStorage;

  // ------------------ MNEMONIC ------------------

  @override
  Future<List<String>> getMnemonic(String address) async {
    final mnemonic = await _storage.read(key: address);
    if (mnemonic == null) {
      // The mnemonic does not exist, no wallet can be created.
      return null;
    }
    return mnemonic.split(' ');
  }

  // ------------------ WALLET ------------------

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
      throw Exception('Error while saving wallet: invalid mnemonic.');
    }

    final wallet = await _generateWalletHelper(mnemonic.split(' '));
    await _storage.write(key: wallet.bech32Address, value: mnemonic.trim());
    return wallet;
  }

  @override
  Future<Wallet> getWallet(String address) async {
    final mnemonic = await getMnemonic(address);
    if (mnemonic == null) return null;
    return _generateWalletHelper(mnemonic);
  }

  // ------------------ ACCOUNTS ------------------

  Future<void> _saveActiveAccount(
    DatabaseClient client,
    MooncakeAccount account,
  ) async {
    await store.record(ACTIVE_ACCOUNT_KEY).put(client, account.toJson());
  }

  Future<List<MooncakeAccount>> _getAccounts(DatabaseClient client) async {
    final jsonAccounts = await store.record(ACCOUNTS_LIST_KEY).get(database);
    if (jsonAccounts == null) {
      // No accounts stored
      return [];
    }

    return (jsonAccounts as List)
        .map((acc) => MooncakeAccount.fromJson(acc as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> setActiveAccount(MooncakeAccount account) async {
    return _saveActiveAccount(database, account);
  }

  @override
  Future<MooncakeAccount> getActiveAccount() async {
    final record = await store.record(ACTIVE_ACCOUNT_KEY).get(database);
    if (record == null) {
      return null;
    }

    return MooncakeAccount.fromJson(record as Map<String, dynamic>);
  }

  @override
  Future<MooncakeAccount> saveAccount(MooncakeAccount data) async {
    await database.transaction((txn) async {
      // Get the stored accounts
      final accounts = (await _getAccounts(txn)).where((acc) {
        // Remove the account with the same address as the new one
        return acc.address != data.address;
      }).toList();

      // Add the new account and convert everything into JSON objects
      final updatedJsonAccounts = (accounts + [data]).map((acc) {
        return acc.toJson();
      }).toList();

      // Store the updated accounts list
      await store.record(ACCOUNTS_LIST_KEY).put(txn, updatedJsonAccounts);

      // Update the current active user if needed
      final currentUser = await getActiveAccount();
      if (currentUser?.address == data.address) {
        await _saveActiveAccount(txn, data);
      }
    });

    return data;
  }

  @override
  Stream<MooncakeAccount> get activeAccountStream {
    return store
        .query(finder: Finder(filter: Filter.byKey(ACTIVE_ACCOUNT_KEY)))
        .onSnapshots(database)
        .map((event) => event.isEmpty
            ? null
            : MooncakeAccount.fromJson(
                event.first.value as Map<String, dynamic>,
              ));
  }

  @override
  Future<MooncakeAccount> getAccount(String address) async {
    // Try getting the account with the required address
    final account = (await _getAccounts(database)).firstWhere(
      (account) => account.address == address,
      orElse: () => null,
    );

    // If the account exists, return it
    if (account != null) {
      return account;
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
    return _getAccounts(database);
  }

  // ------------------ AUTH METHODS ------------------

  @override
  Future<void> saveAuthenticationMethod(
    String address,
    AuthenticationMethod method,
  ) async {
    final methodString = jsonEncode(method.toJson());
    await _storage.write(
      key: '${address}.${AUTHENTICATION_KEY}',
      value: methodString,
    );
  }

  @override
  Future<AuthenticationMethod> getAuthenticationMethod(String address) async {
    final methodString = await _storage.read(
      key: '${address}.${AUTHENTICATION_KEY}',
    );
    if (methodString == null) {
      return null;
    }

    return AuthenticationMethod.fromJson(
      jsonDecode(methodString) as Map<String, dynamic>,
    );
  }

  // ------------------ CLEANUP ------------------

  @override
  Future<void> wipeData() async {
    await _storage.deleteAll();
    await store.delete(database);
  }

  @override
  Future<void> logout(String address) async {
    // remove from list of accounts
    final accounts = await _getAccounts(database);
    final updatedAccountsList = accounts.where((account) {
      return account.address != address;
    }).toList();

    if (updatedAccountsList.isEmpty) {
      // If no account is left, wipe the whole data
      return wipeData();
    }

    final updateJsonAccounts = updatedAccountsList.map((acc) {
      return acc.toJson();
    }).toList();
    await store.record(ACCOUNTS_LIST_KEY).put(database, updateJsonAccounts);

    // Remove wallet
    await _storage.delete(key: address);

    // Switch active account
    await setActiveAccount(updatedAccountsList[0]);
  }
}
