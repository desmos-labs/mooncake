import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/repositories/user/user_repository_impl.dart';

import '../../mocks/mocks.dart';

// ignore: must_be_immutable
class WalletMock extends Mock implements Wallet {}

class RemoteUserSourceMock extends Mock implements RemoteUserSource {}

class LocalUserSourceMock extends Mock implements LocalUserSource {}

void main() {
  RemoteUserSource remoteUserSource;
  LocalUserSource localUserSource;
  UserRepositoryImpl repository;

  setUp(() {
    remoteUserSource = RemoteUserSourceMock();
    localUserSource = LocalUserSourceMock();
    repository = UserRepositoryImpl(
      localUserSource: localUserSource,
      remoteUserSource: remoteUserSource,
    );
  });

  group('saveWallet performs correct calls', () {
    test('when the account does not exist remotely', () async {
      final user = MooncakeAccount.local('address');
      final mockWallet = MockWallet();
      when(localUserSource.saveWallet(any))
          .thenAnswer((_) => Future.value(mockWallet));
      when(localUserSource.getAccount(user.address))
          .thenAnswer((_) => Future.value(user));

      when(remoteUserSource.getAccount(any))
          .thenAnswer((realInvocation) => Future.value(null));

      final wallet = 'wallet';
      await repository.saveWallet(wallet);

      verifyInOrder([
        localUserSource.saveWallet(wallet),
        localUserSource.getAccount(user.address),
        remoteUserSource.getAccount(user.address),
      ]);
      verifyNever(localUserSource.saveAccount(any));
    });

    test('when the account exists remotely', () async {
      final user = MooncakeAccount.local('address');
      final mockWallet = MockWallet();
      when(localUserSource.saveWallet(any))
          .thenAnswer((_) => Future.value(mockWallet));
      when(localUserSource.getAccount(user.address))
          .thenAnswer((_) => Future.value(user));

      final remoteAccount = MooncakeAccount(
        cosmosAccount: CosmosAccount.offline('address'),
        moniker: 'test',
      );
      when(remoteUserSource.getAccount(any))
          .thenAnswer((realInvocation) => Future.value(remoteAccount));

      final wallet = 'wallet';
      await repository.saveWallet(wallet);

      verifyInOrder([
        localUserSource.saveWallet(wallet),
        localUserSource.getAccount(user.address),
        remoteUserSource.getAccount(user.address),
        localUserSource.saveAccount(remoteAccount)
      ]);
    });
  });

  test('getMnemonic works properly', () async {
    final mnemonic = ['mnemonic'];
    when(localUserSource.getMnemonic('address'))
        .thenAnswer((_) => Future.value(mnemonic));

    final result = await repository.getMnemonic('address');
    expect(result, equals(mnemonic));

    verify(localUserSource.getMnemonic('address')).called(1);
  });

  test('getWallet works properly', () async {
    final wallet = WalletMock();
    when(localUserSource.getWallet('address'))
        .thenAnswer((realInvocation) => Future.value(wallet));

    final result = await repository.getWallet('address');
    expect(result, equals(wallet));

    verify(localUserSource.getWallet('address')).called(1);
  });

  group('saveAccount works properly', () {
    test('when syncRemote is false', () async {
      final account = MooncakeAccount.local('address');
      when(localUserSource.saveAccount(any))
          .thenAnswer((_) => Future.value(null));

      final result = await repository.saveAccount(account);
      expect(result, equals(AccountSaveResult.success()));

      verify(localUserSource.saveAccount(account));
      verifyNever(remoteUserSource.saveAccount(any));
    });

    group('when syncRemote is true', () {
      test('and error is returned', () async {
        final account = MooncakeAccount.local('address');
        final expected = AccountSaveResult.error('My error');
        when(remoteUserSource.saveAccount(any))
            .thenAnswer((_) => Future.value(expected));

        final result = await repository.saveAccount(account, syncRemote: true);
        expect(result, equals(expected));

        verify(remoteUserSource.saveAccount(account)).called(1);
        verifyNever(localUserSource.saveAccount(account));
      });

      test('and success is returned', () async {
        final account = MooncakeAccount.local('address');
        final expected = AccountSaveResult.success();

        when(remoteUserSource.saveAccount(any))
            .thenAnswer((_) => Future.value(expected));
        when(localUserSource.saveAccount(any))
            .thenAnswer((_) => Future.value(null));

        final result = await repository.saveAccount(account, syncRemote: true);
        expect(result, equals(expected));

        verifyInOrder([
          remoteUserSource.saveAccount(account),
          localUserSource.saveAccount(account),
        ]);
      });
    });
  });

  group('getAccount works properly', () {
    test('when account does not exist locally', () async {
      when(localUserSource.getAccount('address'))
          .thenAnswer((_) => Future.value(null));

      final result = await repository.getAccount('address');
      expect(result, isNull);

      verify(localUserSource.getAccount('address')).called(1);
    });

    test('when account exists locally', () async {
      final account = MooncakeAccount.local('address');
      when(localUserSource.getAccount(account.address))
          .thenAnswer((_) => Future.value(account));

      final result = await repository.getAccount(account.address);
      expect(result, equals(account));

      verify(localUserSource.getAccount(account.address)).called(1);
    });
  });

  group('getAccounts works properly', () {
    test('when accounts does not exist locally', () async {
      when(localUserSource.getAccounts()).thenAnswer((_) => Future.value([]));

      final result = await repository.getAccounts();
      expect(result, equals([]));

      verify(localUserSource.getAccounts()).called(1);
    });

    test('when accounts exists locally', () async {
      final account = MooncakeAccount.local('address');
      when(localUserSource.getAccounts())
          .thenAnswer((_) => Future.value([account]));

      final result = await repository.getAccounts();
      expect(result, equals([account]));

      verify(localUserSource.getAccounts()).called(1);
    });
  });

  group('getActiveAccount works properly', () {
    test('when account does not exist locally', () async {
      when(localUserSource.getActiveAccount())
          .thenAnswer((_) => Future.value(null));

      final result = await repository.getActiveAccount();
      expect(result, isNull);

      verify(localUserSource.getActiveAccount()).called(1);
    });

    test('when account exists locally', () async {
      final account = MooncakeAccount.local('address');
      when(localUserSource.getActiveAccount())
          .thenAnswer((_) => Future.value(account));

      final result = await repository.getActiveAccount();
      expect(result, equals(account));

      verify(localUserSource.getActiveAccount()).called(1);
    });
  });

  group('refreshAccount works properly', () {
    test('when account does not exist locally', () async {
      when(localUserSource.getAccount('address'))
          .thenAnswer((_) => Future.value(null));

      final stored = await repository.refreshAccount('address');
      expect(stored, isNull);

      verify(localUserSource.getAccount('address')).called(1);
      verifyNever(remoteUserSource.getAccount(any));
    });

    test('when the account existing locally but not on chain', () async {
      final account = MooncakeAccount.local('address');
      when(localUserSource.getAccount(account.address))
          .thenAnswer((_) => Future.value(account));
      when(remoteUserSource.getAccount(any))
          .thenAnswer((_) => Future.value(null));

      final stored = await repository.refreshAccount(account.address);
      expect(stored, equals(account));

      verifyInOrder([
        localUserSource.getAccount(account.address),
        remoteUserSource.getAccount(account.address),
      ]);

      verifyNever(localUserSource.saveAccount(any));
    });

    test('when account existing locally and on-chain', () async {
      final account = MooncakeAccount.local('address');
      when(localUserSource.getAccount(account.address))
          .thenAnswer((_) => Future.value(account));

      final remoteAccount = account.copyWith(moniker: 'test-moniker');
      when(remoteUserSource.getAccount(any))
          .thenAnswer((_) => Future.value(remoteAccount));
      when(localUserSource.saveAccount(any))
          .thenAnswer((_) => Future.value(remoteAccount));

      final stored = await repository.refreshAccount(account.address);
      expect(stored, equals(remoteAccount));

      verifyInOrder([
        localUserSource.getAccount(account.address),
        remoteUserSource.getAccount(account.address),
        localUserSource.saveAccount(remoteAccount),
      ]);
    });
  });

  group('setAccountActive works properly', () {
    test('works properly', () async {
      final account = MooncakeAccount.local('address');
      when(localUserSource.setActiveAccount(account))
          .thenAnswer((_) => Future.value(null));

      await repository.setActiveAccount(account);

      verify(localUserSource.setActiveAccount(account)).called(1);
    });
  });

  test('accountStream emits correct events', () {
    final account = MooncakeAccount.local('address');
    final controller = StreamController<MooncakeAccount>();

    when(localUserSource.activeAccountStream)
        .thenAnswer((_) => controller.stream);

    final stream = repository.activeAccountStream;
    expectLater(
        stream,
        emitsInOrder([
          account,
          account.copyWith(moniker: 'John Doe'),
          account.copyWith(dtag: 'John')
        ]));

    controller.add(account);
    controller.add(account.copyWith(moniker: 'John Doe'));
    controller.add(account.copyWith(dtag: 'John'));
    controller.close();
  });

  test('fundAccount performs correct calls', () async {
    final account = MooncakeAccount.local('address');
    when(remoteUserSource.fundAccount(any))
        .thenAnswer((_) => Future.value(null));

    await repository.fundAccount(account);

    verify(remoteUserSource.fundAccount(account)).called(1);
  });

  test('saveAuthenticationMethod performs correct calls', () async {
    final method = PasswordAuthentication(hashedPassword: 'password');
    when(localUserSource.saveAuthenticationMethod('address', any))
        .thenAnswer((_) => Future.value(null));

    await repository.saveAuthenticationMethod('address', method);

    verify(localUserSource.saveAuthenticationMethod('address', method))
        .called(1);
  });

  test('getAuthenticationMethod performs correct calls', () async {
    final method = PasswordAuthentication(hashedPassword: 'password');
    when(localUserSource.getAuthenticationMethod('address'))
        .thenAnswer((_) => Future.value(method));

    final result = await repository.getAuthenticationMethod('address');
    expect(result, equals(method));

    verify(localUserSource.getAuthenticationMethod('address')).called(1);
  });

  test('deleteData performs correct calls', () async {
    when(localUserSource.wipeData()).thenAnswer((_) => Future.value(null));

    await repository.deleteData();

    verify(localUserSource.wipeData()).called(1);
  });

  test('logout performs correct calls', () async {
    when(localUserSource.logout('account'))
        .thenAnswer((_) => Future.value(null));

    await repository.logout('account');

    verify(localUserSource.logout('account')).called(1);
  });
}
