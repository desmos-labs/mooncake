import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/account/export.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/sources/sources.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:test/test.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

// Tests for the LocalUserSourceImpl class
void main() {
  Database database;
  NetworkInfo networkInfo;
  MockSecureStorage secureStorage;

  LocalUserSourceImpl source;

  setUp(() async {
    networkInfo = NetworkInfo(bech32Hrp: "desmos", lcdUrl: "localhost");
    secureStorage = MockSecureStorage();
    database = await databaseFactoryMemory
        .openDatabase(DateTime.now().toIso8601String());

    source = LocalUserSourceImpl(
      database: database,
      networkInfo: networkInfo,
      secureStorage: secureStorage,
    );
  });

  group('Wallet', () {
    test('saveWallet throws error with invalid mnemonic', () async {
      final mnemonic = "1234567689";
      expect(() => source.saveWallet(mnemonic), throwsException);
      verifyZeroInteractions(secureStorage);
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
      Wallet wallet = await source.saveWallet(mnemonic);
      verify(secureStorage.write(
        key: wallet.bech32Address,
        value: mnemonic,
      ));
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

      when(secureStorage.read(
              key: "desmos1zg0dnufdsnua3skd82r0fdv2v92kupc4tyv4fv"))
          .thenAnswer((_) => Future.value(mnemonic));

      final wallet = await source
          .getWallet("desmos1zg0dnufdsnua3skd82r0fdv2v92kupc4tyv4fv");
      expect(
        wallet?.bech32Address,
        "desmos1zg0dnufdsnua3skd82r0fdv2v92kupc4tyv4fv",
      );
    });
  });

  group('Account', () {
    test('saveAccount works properly', () async {
      final account = MooncakeAccount(
        moniker: null,
        profilePicUri: null,
        cosmosAccount: CosmosAccount(
          address: "address",
          accountNumber: "1",
          sequence: "1",
          coins: [],
        ),
      );

      await source.saveAccount(account);

      final store = StoreRef.main();
      final record = await store.findFirst(
        database,
        finder: Finder(filter: Filter.byKey(LocalUserSourceImpl.USER_DATA_KEY)),
      );
      final stored = MooncakeAccount.fromJson(
        record.value as Map<String, dynamic>,
      );
      expect(stored, equals(account));
    });

    test('getAccount returns the correctly stored data', () async {
      final account = MooncakeAccount(
        profilePicUri: "https://example.com/avatar.png",
        moniker: "john-doe",
        cosmosAccount: CosmosAccount(
          accountNumber: "153",
          sequence: "45",
          address: "desmos1ew60ztvqxlf5kjjyyzxf7hummlwdadgesu3725",
          coins: [
            StdCoin(amount: "10000", denom: "udaric"),
          ],
        ),
      );

      final store = StoreRef.main();
      await store.record(LocalUserSourceImpl.USER_DATA_KEY).put(
            database,
            account.toJson(),
          );

      final stored = await source.getAccount();
      expect(stored, equals(account));
    });

    test('getAccount returns null when no data is saved', () async {
      expect(await source.getAccount(), isNull);
    });
  });

  group('Authentication method', () {
    test('saveAuthenticationMethod works with biometric auth', () async {
      final auth = BiometricAuthentication();
      when(secureStorage.write(
        key: anyNamed("key"),
        value: anyNamed("value"),
      )).thenAnswer((_) => null);

      await source.saveAuthenticationMethod(auth);

      verify(secureStorage.write(
        key: LocalUserSourceImpl.AUTHENTICATION_KEY,
        value: jsonEncode(auth.toJson()),
      ));
    });

    test('saveAuthenticationMethod works with password auth', () async {
      final auth = PasswordAuthentication(
        hashedPassword: "5f4dcc3b5aa765d61d8327deb882cf99",
      );
      when(secureStorage.write(
        key: anyNamed("key"),
        value: anyNamed("value"),
      )).thenAnswer((_) => null);

      await source.saveAuthenticationMethod(auth);

      verify(secureStorage.write(
        key: LocalUserSourceImpl.AUTHENTICATION_KEY,
        value: jsonEncode(auth.toJson()),
      ));
    });

    test('getAuthenticationMethod returns null whe non existing', () async {
      final authMethod = await source.getAuthenticationMethod();
      expect(authMethod, isNull);
    });

    test('getAuthenticationMethod returns valid biometric data', () async {
      final authMethod = BiometricAuthentication();
      when(secureStorage.read(key: LocalUserSourceImpl.AUTHENTICATION_KEY))
          .thenAnswer((realInvocation) async {
        return jsonEncode(authMethod.toJson());
      });

      final stored = await source.getAuthenticationMethod();
      expect(stored, equals(authMethod));
    });

    test('getAuthenticationMethod returns valid biometric data', () async {
      final authMethod = PasswordAuthentication(
          hashedPassword: "202cb962ac59075b964b07152d234b70");
      when(secureStorage.read(key: LocalUserSourceImpl.AUTHENTICATION_KEY))
          .thenAnswer((realInvocation) async {
        return jsonEncode(authMethod.toJson());
      });

      final stored = await source.getAuthenticationMethod();
      expect(stored, equals(authMethod));
    });
  });

  group('Data wiping', () {
    test('correctly deletes data', () async {
      final account = MooncakeAccount(
        profilePicUri: "https://example.com/avatar",
        moniker: "account",
        cosmosAccount: CosmosAccount(
          address: "address",
          accountNumber: "1",
          sequence: "1",
          coins: [],
        ),
      );

      final store = StoreRef.main();
      await store.record(LocalUserSourceImpl.USER_DATA_KEY).put(
            database,
            account.toJson(),
          );

      when(secureStorage.deleteAll())
          .thenAnswer((realInvocation) => Future.value(null));

      await source.wipeData();

      final count = await store.count(database);
      expect(count, isZero);
      verify(secureStorage.deleteAll());
    });
  });
}
