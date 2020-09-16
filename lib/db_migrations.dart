import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:sembast/sembast.dart';

/// Migrates the database from version 1 to version 2.
///
/// This is necessary since from Cosmos v0.38 to v0.39 the serialization of
/// the account has changed and the account_number and sequence are now string
/// instead of the previous integers.
Future<void> migrateV1AccountDatabase(DatabaseClient db) async {
  final store = StoreRef.main();
  final record = await store.record('user_data').get(db);
  if (record == null) return;

  final json = Map.from(record as Map<String, dynamic>);
  final cosmos = Map.from(json['cosmos_account'] as Map<String, dynamic>);

  final accNumber = cosmos['account_number'];
  if (accNumber is int) {
    final stringAccNumber = accNumber < 0 ? '' : accNumber.toString();
    cosmos.update('account_number', (value) => stringAccNumber);
  }

  final sequence = cosmos['sequence'];
  if (sequence is int) {
    final stringSequence = sequence < 0 ? '' : accNumber.toString();
    cosmos.update('sequence', (value) => stringSequence);
  }

  json.update('cosmos_account', (value) => cosmos);
  await store.record('user_data').update(db, json);
}

/// From version 2 of the database to version 3, we changed how the accounts
/// are stored locally. Instead of having a single account, now we have a list
/// of them.
Future<void> migrateV2AccountDatabase(DatabaseClient db) async {
  final store = StoreRef.main();
  final storage = FlutterSecureStorage();

  // --- ACCOUNT ---

  // Get the account
  final userRecord = await store.record('user_data').get(db);
  if (userRecord == null) return;

  final account = MooncakeAccount.fromJson(userRecord as Map<String, dynamic>);
  final jsonAccount = account.toJson();

  // Save the account inside the list of accounts and as the active one
  await store.record('accounts').put(db, [jsonAccount]);
  await store.record('active_account').put(db, jsonAccount);

  // --- AUTH METHOD ---

  // Get the authentication method
  final authString = await storage.read(key: 'authentication');
  if (authString == null) return;

  // Save the authentication method for the account
  await storage.write(
    key: '${account.address}.authentication',
    value: authString,
  );

  // --- MNEMONIC ---

  // Get the stored mnemonic
  final mnemonicString = await storage.read(key: 'mnemonic');
  if (mnemonicString == null) return;

  // Save the mnemonic for the account
  await storage.write(key: account.address, value: mnemonicString);

  // --- CLEAN UP ---

  // Remove the old keys
  await store.record('user_data').delete(db);
  await storage.delete(key: 'authentication');
  await storage.delete(key: 'mnemonic');
}

/// Deletes all the local posts since they need to be re-downloaded
/// from the remote source.
Future<void> deletePosts(DatabaseClient db) async {
  final store = StoreRef.main();
  await store.delete(db);
}
