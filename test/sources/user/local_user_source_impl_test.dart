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

  final testDir = "./tmp";
  final lcdUrl = "http://lcd.morpheus.desmos.network:1317";
  final networkInfo = NetworkInfo(bech32Hrp: "desmos", lcdUrl: lcdUrl);
  FlutterSecureStorage storage;
  LocalUserSourceImpl source;

  setUpAll(() {
    final tempDir = Directory(testDir);
    tempDir.createSync();
  });

  tearDownAll(() {
    final tempDir = Directory(testDir);
    tempDir.deleteSync(recursive: true);
  });

  setUp(() {
    // Mock for the path provider
    final channel = MethodChannel('plugins.flutter.io/path_provider');
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return testDir;
    });

    storage = MockSecureStorage();
    source = LocalUserSourceImpl(
      dbName: DateTime.now().toIso8601String(),
      networkInfo: networkInfo,
      secureStorage: storage,
    );
  });

  group('saveWallet and getWallet', () {
    test('saveWallet throws error with invalid mnemonic', () async {
      final mnemonic = "1234567689";
      expect(() => source.saveWallet(mnemonic), throwsException);

      verifyZeroInteractions(storage);
    });

    test('saveWallet works properly with valid mnemonic', () async {
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

    test('getWallet works properly', () async {
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

  group('getAddress', () {
    test('getAddress uses wallet if AccountData is null', () async {
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

    test('getAddress uses AccountData if found', () async {
      when(storage.read(key: "mnemonic")).thenAnswer((_) => Future.value(null));
      expect(await source.getWallet(), isNull);

      final accountData = AccountData(
        address: "address",
        accountNumber: "1",
        sequence: "1",
        coins: [],
      );
      await source.saveAccountData(accountData);
      expect(await source.getAccountData(), accountData);

      expect(await source.getAddress(), accountData.address);
    });
  });

  group('saveAccountData and getAccountData', () {
    test('getAccountData returns null when no data is saved', () async {
      expect(await source.getAccountData(), isNull);
    });

    test('saveAccountData and getAccountData work properly', () async {
      final accountData = AccountData(
        address: "address",
        accountNumber: "1",
        sequence: "1",
        coins: [],
      );

      await source.saveAccountData(accountData);

      expect(await source.getAccountData(), accountData);
    });
  });

  group('wipeData', () {
    test('wipeData correctly deletes data', () async {
      final accountData = AccountData(
        address: "address",
        accountNumber: "1",
        sequence: "1",
        coins: [],
      );
      await source.saveAccountData(accountData);
      expect(await source.getAccountData(), isNotNull);

      await source.wipeData();

      expect(await source.getWallet(), isNull);
      expect(await source.getAccountData(), isNull);
    });
  });
}
