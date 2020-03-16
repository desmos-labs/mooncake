import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/sources/sources.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

// Tests for the LocalUserSourceImpl class
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Temporary directory in which all the databases will be saved
  final tempDir = Directory("./tmp");
  final lcdUrl = "http://lcd.morpheus.desmos.network:1317";
  final networkInfo = NetworkInfo(bech32Hrp: "desmos", lcdUrl: lcdUrl);
  FlutterSecureStorage storage;
  LocalUserSourceImpl source;

  setUpAll(() {
    // Mock for the path provider
    final channel = MethodChannel('plugins.flutter.io/path_provider');
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return tempDir.path;
    });

    // Create the temporary directory
    tempDir.createSync();
  });

  tearDownAll(() {
    // Delete the temp dir after all the tests
    tempDir.deleteSync(recursive: true);
  });

  setUp(() {
    storage = MockSecureStorage();
    source = LocalUserSourceImpl(
      dbName: DateTime.now().toIso8601String(),
      networkInfo: networkInfo,
      secureStorage: storage,
    );
  });

  group('Wallet', () {
    test('saving throws error with invalid mnemonic', () async {
      final mnemonic = "1234567689";
      expect(() => source.saveWallet(mnemonic), throwsException);

      verifyZeroInteractions(storage);
    });

    test('saving works properly with valid mnemonic', () async {
      final mnemonic = [
        "potato",
        "already",
        "proof",
        "alien",
        "rent",
        "hawk",
        "settle",
        "settle",
        "brush",
        "chase",
        "cage",
        "shell",
        "marriage",
        "drop",
        "foil",
        "garment",
        "solar",
        "join",
        "involve",
        "stock",
        "coffee",
        "toddler",
        "blur",
        "pool",
      ].join(" ");
      await source.saveWallet(mnemonic);
      verify(storage.write(key: "mnemonic", value: mnemonic));
    });

    test('reading works properly', () async {
      final mnemonic = [
        "potato",
        "already",
        "proof",
        "alien",
        "rent",
        "hawk",
        "settle",
        "settle",
        "brush",
        "chase",
        "cage",
        "shell",
        "marriage",
        "drop",
        "foil",
        "garment",
        "solar",
        "join",
        "involve",
        "stock",
        "coffee",
        "toddler",
        "blur",
        "pool",
      ].join(" ");

      when(storage.read(key: "mnemonic"))
          .thenAnswer((_) => Future.value(mnemonic));

      final wallet = await source.getWallet();
      expect(
        wallet?.bech32Address,
        "desmos1zg0dnufdsnua3skd82r0fdv2v92kupc4tyv4fv",
      );
    });
  });

  group('Address', () {
    test('reading uses wallet if AccountData is null', () async {
      final mnemonic = [
        "potato",
        "already",
        "proof",
        "alien",
        "rent",
        "hawk",
        "settle",
        "settle",
        "brush",
        "chase",
        "cage",
        "shell",
        "marriage",
        "drop",
        "foil",
        "garment",
        "solar",
        "join",
        "involve",
        "stock",
        "coffee",
        "toddler",
        "blur",
        "pool",
      ].join(" ");

      when(storage.read(key: "mnemonic"))
          .thenAnswer((_) => Future.value(mnemonic));

      expect(await source.getAccountData(), isNull);

      final address = await source.getAddress();
      expect(address, "desmos1zg0dnufdsnua3skd82r0fdv2v92kupc4tyv4fv");
    });

    test('reading uses AccountData if found', () async {
      when(storage.read(key: "mnemonic")).thenAnswer((_) => Future.value(null));
      expect(await source.getWallet(), isNull);

      final accountData = AccountData(
        address: "address",
        accountNumber: 1,
        sequence: 1,
        coins: [],
      );
      await source.saveAccount(accountData);
      expect(await source.getAccountData(), accountData);

      expect(await source.getAddress(), accountData.address);
    });
  });

  group('AccountData', () {
    test('reading returns null when no data is saved', () async {
      expect(await source.getAccountData(), isNull);
    });

    test('saving and getAccountData work properly', () async {
      final accountData = AccountData(
        address: "address",
        accountNumber: 1,
        sequence: 1,
        coins: [],
      );

      await source.saveAccount(accountData);

      expect(await source.getAccountData(), accountData);
    });
  });

  group('Data wiping', () {
    test('correctly deletes data', () async {
      final accountData = AccountData(
        address: "address",
        accountNumber: 1,
        sequence: 1,
        coins: [],
      );
      await source.saveAccount(accountData);
      expect(await source.getAccountData(), isNotNull);

      await source.wipeData();

      expect(await source.getWallet(), isNull);
      expect(await source.getAccountData(), isNull);
    });
  });
}
