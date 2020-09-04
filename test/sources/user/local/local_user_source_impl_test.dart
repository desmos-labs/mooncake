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
    networkInfo = NetworkInfo(bech32Hrp: 'desmos', lcdUrl: 'localhost');
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
      final mnemonic = '1234567689';
      expect(() => source.saveWallet(mnemonic), throwsException);
      verifyZeroInteractions(secureStorage);
    });

    test('saveWallet works properly with valid mnemonic', () async {
      final mnemonic = [
        'potato',
        'already',
        'proof',
        'alien',
        'rent',
        'hawk',
        'settle',
        'settle',
        'brush',
        'chase',
        'cage',
        'shell',
        'marriage',
        'drop',
        'foil',
        'garment',
        'solar',
        'join',
        'involve',
        'stock',
        'coffee',
        'toddler',
        'blur',
        'pool',
      ].join(' ');
      var wallet = await source.saveWallet(mnemonic);
      verify(secureStorage.write(
        key: wallet.bech32Address,
        value: mnemonic,
      ));
    });

    test('getWallet works properly', () async {
      final mnemonic = [
        'potato',
        'already',
        'proof',
        'alien',
        'rent',
        'hawk',
        'settle',
        'settle',
        'brush',
        'chase',
        'cage',
        'shell',
        'marriage',
        'drop',
        'foil',
        'garment',
        'solar',
        'join',
        'involve',
        'stock',
        'coffee',
        'toddler',
        'blur',
        'pool',
      ].join(' ');

      when(secureStorage.read(
              key: 'desmos1zg0dnufdsnua3skd82r0fdv2v92kupc4tyv4fv'))
          .thenAnswer((_) => Future.value(mnemonic));

      final wallet = await source
          .getWallet('desmos1zg0dnufdsnua3skd82r0fdv2v92kupc4tyv4fv');
      expect(
        wallet?.bech32Address,
        'desmos1zg0dnufdsnua3skd82r0fdv2v92kupc4tyv4fv',
      );
    });
  });

  group('Account', () {
    group('saveAccount', () {
      final account = MooncakeAccount.local('address');

      test('stores the account with no existing ones', () async {
        await source.saveAccount(account);

        final store = StoreRef.main();
        final record = await store.findFirst(
          database,
          finder: Finder(
            filter: Filter.byKey(LocalUserSourceImpl.ACCOUNTS_LIST_KEY),
          ),
        );

        final stored = MooncakeAccount.fromJson(
          record.value[0] as Map<String, dynamic>,
        );
        expect(stored, equals(account));
      });

      test('replaces existing account with same address', () async {
        final updatedAccount = account.copyWith(
          cosmosAccount: account.cosmosAccount.copyWith(
            accountNumber: '20',
          ),
        );

        await source.saveAccount(account);
        await source.saveAccount(updatedAccount);

        final store = StoreRef.main();
        final record = await store.findFirst(
          database,
          finder: Finder(
            filter: Filter.byKey(LocalUserSourceImpl.ACCOUNTS_LIST_KEY),
          ),
        );

        final value = record.value as List;
        expect(value.length, equals(1));

        final stored =
            MooncakeAccount.fromJson(value[0] as Map<String, dynamic>);
        expect(
          stored.cosmosAccount.accountNumber,
          equals(updatedAccount.cosmosAccount.accountNumber),
        );
      });

      test('updates active account', () async {
        await source.setActiveAccount(account);
        final updatedAccount = account.copyWith(
          cosmosAccount: account.cosmosAccount.copyWith(
            accountNumber: '20',
          ),
        );
        await source.saveAccount(updatedAccount);

        final store = StoreRef.main();
        final record = await store.findFirst(
          database,
          finder: Finder(
            filter: Filter.byKey(LocalUserSourceImpl.ACTIVE_ACCOUNT_KEY),
          ),
        );

        final stored = MooncakeAccount.fromJson(
          record.value as Map<String, dynamic>,
        );
        expect(stored, equals(updatedAccount));
      });
    });

    group('setActiveAccount', () {
      final account = MooncakeAccount.local('address');

      test('works properly with no prior account stored', () async {
        await source.setActiveAccount(account);

        final store = StoreRef.main();
        final record = await store.findFirst(
          database,
          finder: Finder(
            filter: Filter.byKey(LocalUserSourceImpl.ACTIVE_ACCOUNT_KEY),
          ),
        );

        final stored = MooncakeAccount.fromJson(
          record.value as Map<String, dynamic>,
        );
        expect(stored, equals(account));
      });

      test('replaces existing account properly', () async {
        final store = StoreRef.main();
        await store
            .record(LocalUserSourceImpl.ACTIVE_ACCOUNT_KEY)
            .update(database, account.toJson());

        final updatedAccount = account.copyWith(bio: 'Updated bio');
        await source.setActiveAccount(updatedAccount);

        final record = await store.findFirst(
          database,
          finder: Finder(
            filter: Filter.byKey(LocalUserSourceImpl.ACTIVE_ACCOUNT_KEY),
          ),
        );

        final stored = MooncakeAccount.fromJson(
          record.value as Map<String, dynamic>,
        );
        expect(stored, equals(updatedAccount));
      });
    });

    group('getActiveAccount', () {
      test('returns null when no data is saved', () async {
        expect(await source.getActiveAccount(), isNull);
      });

      test('returns with account', () async {
        final account = MooncakeAccount.local('test-address');

        final store = StoreRef.main();
        await store
            .record(LocalUserSourceImpl.ACTIVE_ACCOUNT_KEY)
            .put(database, account.toJson());

        expect(await source.getActiveAccount(), account);
      });
    });

    group('getAccount', () {
      test('getAccount returns null when no data is saved', () async {
        expect(await source.getAccount('account'), isNull);
      });

      test('getAccount returns the correctly stored data', () async {
        final firstAccount = MooncakeAccount.local('test-address');
        final secondAccount = MooncakeAccount.local('second-address');

        final store = StoreRef.main();
        await store
            .record(LocalUserSourceImpl.ACCOUNTS_LIST_KEY)
            .put(database, [firstAccount.toJson(), secondAccount.toJson()]);

        final stored = await source.getAccount(firstAccount.address);
        expect(stored, equals(firstAccount));

        final storedTwo = await source.getAccount(secondAccount.address);
        expect(storedTwo, equals(secondAccount));
      });
    });

    group('getAccounts', () {
      test('getAccounts returns empty list when no data is saved', () async {
        expect(await source.getAccounts(), isEmpty);
      });

      test('getAccounts returns list when data is present', () async {
        final account = MooncakeAccount.local('first-address');
        final accountTwo = MooncakeAccount.local('second-accounts');

        final store = StoreRef.main();
        await store
            .record(LocalUserSourceImpl.ACCOUNTS_LIST_KEY)
            .put(database, [account.toJson(), accountTwo.toJson()]);

        expect(await source.getAccounts(), equals([account, accountTwo]));
      });
    });
  });

  group('Authentication method', () {
    group('saveAuthenticationMethod', () {
      test('works with biometric auth', () async {
        final auth = BiometricAuthentication();
        when(secureStorage.write(
          key: anyNamed('key'),
          value: anyNamed('value'),
        )).thenAnswer((_) => null);

        await source.saveAuthenticationMethod('address', auth);

        verify(secureStorage.write(
          key: 'address.${LocalUserSourceImpl.AUTHENTICATION_KEY}',
          value: jsonEncode(auth.toJson()),
        ));
      });

      test('works with password auth', () async {
        final auth = PasswordAuthentication(
          hashedPassword: '5f4dcc3b5aa765d61d8327deb882cf99',
        );
        when(secureStorage.write(
          key: anyNamed('key'),
          value: anyNamed('value'),
        )).thenAnswer((_) => null);

        await source.saveAuthenticationMethod('address', auth);

        verify(secureStorage.write(
          key: 'address.${LocalUserSourceImpl.AUTHENTICATION_KEY}',
          value: jsonEncode(auth.toJson()),
        ));
      });
    });

    group('getAuthenticationMethod', () {
      test('returns null whe non existing', () async {
        final authMethod = await source.getAuthenticationMethod('address');
        expect(authMethod, isNull);
      });

      test('returns valid biometric data', () async {
        final authMethod = BiometricAuthentication();
        when(secureStorage.read(
                key: 'address.${LocalUserSourceImpl.AUTHENTICATION_KEY}'))
            .thenAnswer((realInvocation) async {
          return jsonEncode(authMethod.toJson());
        });

        final stored = await source.getAuthenticationMethod('address');
        expect(stored, equals(authMethod));
      });

      test('returns valid biometric data', () async {
        final authMethod = PasswordAuthentication(
            hashedPassword: '202cb962ac59075b964b07152d234b70');
        when(secureStorage.read(
                key: 'address.${LocalUserSourceImpl.AUTHENTICATION_KEY}'))
            .thenAnswer((realInvocation) async {
          return jsonEncode(authMethod.toJson());
        });

        final stored = await source.getAuthenticationMethod('address');
        expect(stored, equals(authMethod));
      });
    });
  });

  group('Data wiping and logout', () {
    final account = MooncakeAccount.local('test-address');

    group('wipeData', () {
      test('correctly deletes data', () async {
        final store = StoreRef.main();
        await store
            .record(LocalUserSourceImpl.ACTIVE_ACCOUNT_KEY)
            .put(database, account.toJson());

        when(secureStorage.deleteAll())
            .thenAnswer((realInvocation) => Future.value(null));

        await source.wipeData();

        final count = await store.count(database);
        expect(count, isZero);
        verify(secureStorage.deleteAll());
      });
    });

    group('logout', () {
      test('does nothing with non existing user', () async {
        final store = StoreRef.main();
        await store
            .record(LocalUserSourceImpl.ACCOUNTS_LIST_KEY)
            .put(database, [account.toJson()]);

        await store
            .record(LocalUserSourceImpl.ACTIVE_ACCOUNT_KEY)
            .put(database, account.toJson());

        await source.logout('impossibleAddress');
        verifyNever(secureStorage.deleteAll());

        final active = await store
            .record(LocalUserSourceImpl.ACTIVE_ACCOUNT_KEY)
            .get(database);

        expect(
          MooncakeAccount.fromJson(active as Map<String, dynamic>),
          equals(account),
        );
      });

      test('correctly deletes one user', () async {
        final store = StoreRef.main();
        await store
            .record(LocalUserSourceImpl.ACCOUNTS_LIST_KEY)
            .put(database, [account.toJson()]);

        when(secureStorage.deleteAll())
            .thenAnswer((realInvocation) => Future.value(null));

        await source.logout(account.address);

        final count = await store.count(database);
        expect(count, isZero);
        verify(secureStorage.deleteAll()).called(1);
      });

      test('correctly deletes one user if multiple accounts exist', () async {
        final secondAccount = account.copyWith(
          cosmosAccount: account.cosmosAccount.copyWith(
            address: 'second-address',
          ),
        );

        final store = StoreRef.main();
        await store
            .record(LocalUserSourceImpl.ACTIVE_ACCOUNT_KEY)
            .put(database, account.toJson());

        await store
            .record(LocalUserSourceImpl.ACCOUNTS_LIST_KEY)
            .put(database, [account.toJson(), secondAccount.toJson()]);

        await source.logout(account.address);

        verifyNever(secureStorage.deleteAll());

        final allAccounts = await store.findFirst(
          database,
          finder: Finder(
            filter: Filter.byKey(LocalUserSourceImpl.ACCOUNTS_LIST_KEY),
          ),
        );

        final allAccountsValues = allAccounts.value as List;
        expect(allAccountsValues.length, equals(1));

        final remainingRecord = await store.findFirst(
          database,
          finder: Finder(
            filter: Filter.byKey(LocalUserSourceImpl.ACTIVE_ACCOUNT_KEY),
          ),
        );

        final remainingStored = MooncakeAccount.fromJson(
          remainingRecord.value as Map<String, dynamic>,
        );
        expect(remainingStored, equals(secondAccount));
      });
    });
  });
}
