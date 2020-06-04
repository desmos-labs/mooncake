import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/repositories/user/user_repository_impl.dart';

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
      final user = MooncakeAccount.local("address");
      when(localUserSource.saveWallet(any))
          .thenAnswer((_) => Future.value(null));
      when(localUserSource.getAccount()).thenAnswer((_) => Future.value(user));

      when(remoteUserSource.getAccount(any))
          .thenAnswer((realInvocation) => Future.value(null));

      final wallet = "wallet";
      await repository.saveWallet(wallet);

      verifyInOrder([
        localUserSource.saveWallet(wallet),
        localUserSource.getAccount(),
        remoteUserSource.getAccount(user.address),
      ]);
      verifyNever(localUserSource.saveAccount(any));
    });

    test('when the account exists remotely', () async {
      final user = MooncakeAccount.local("address");
      when(localUserSource.saveWallet(any))
          .thenAnswer((_) => Future.value(null));
      when(localUserSource.getAccount()).thenAnswer((_) => Future.value(user));

      final remoteAccount = MooncakeAccount(
        cosmosAccount: CosmosAccount.offline("address"),
        moniker: "test",
      );
      when(remoteUserSource.getAccount(any))
          .thenAnswer((realInvocation) => Future.value(remoteAccount));

      final wallet = "wallet";
      await repository.saveWallet(wallet);

      verifyInOrder([
        localUserSource.saveWallet(wallet),
        localUserSource.getAccount(),
        remoteUserSource.getAccount(user.address),
        localUserSource.saveAccount(remoteAccount)
      ]);
    });
  });

  test('getMnemonic works properly', () async {
    final mnemonic = ["mnemonic"];
    when(localUserSource.getMnemonic())
        .thenAnswer((_) => Future.value(mnemonic));

    final result = await repository.getMnemonic();
    expect(result, equals(mnemonic));

    verify(localUserSource.getMnemonic()).called(1);
  });

  test('getWallet works properly', () async {
    final wallet = WalletMock();
    when(localUserSource.getWallet())
        .thenAnswer((realInvocation) => Future.value(wallet));

    final result = await repository.getWallet();
    expect(result, equals(wallet));

    verify(localUserSource.getWallet()).called(1);
  });

  test('saveAccount works properly', () async {
    final account = MooncakeAccount.local("address");
    when(localUserSource.saveAccount(any))
        .thenAnswer((_) => Future.value(null));
    when(remoteUserSource.saveAccount(any))
        .thenAnswer((_) => Future.value(null));

    await repository.saveAccount(account);

    verifyInOrder([
      localUserSource.saveAccount(account),
      remoteUserSource.saveAccount(account),
    ]);
  });

  group('getAccount works properly', () {
    test('when account does not exist locally', () async {
      when(localUserSource.getAccount()).thenAnswer((_) => Future.value(null));

      final result = await repository.getAccount();
      expect(result, isNull);

      verify(localUserSource.getAccount()).called(1);
    });

    test('when account exists locally', () async {
      final account = MooncakeAccount.local("address");
      when(localUserSource.getAccount())
          .thenAnswer((_) => Future.value(account));

      final result = await repository.getAccount();
      expect(result, equals(account));

      verify(localUserSource.getAccount()).called(1);
    });
  });

  group('refreshAccount works properly', () {
    test('when account does not exist locally', () async {
      when(localUserSource.getAccount()).thenAnswer((_) => Future.value(null));

      await repository.refreshAccount();

      verify(localUserSource.getAccount()).called(1);
      verifyNever(remoteUserSource.getAccount(any));
    });

    test('when the account existing locally but not on chain', () async {
      final account = MooncakeAccount.local("address");
      when(localUserSource.getAccount())
          .thenAnswer((_) => Future.value(account));
      when(remoteUserSource.getAccount(any))
          .thenAnswer((_) => Future.value(null));

      await repository.refreshAccount();

      verifyInOrder([
        localUserSource.getAccount(),
        remoteUserSource.getAccount(account.address),
      ]);

      verifyNever(localUserSource.saveAccount(any));
    });

    test('when account existing locally and on-chain', () async {
      final account = MooncakeAccount.local("address");
      when(localUserSource.getAccount())
          .thenAnswer((_) => Future.value(account));

      final remoteAccount = account.copyWith(moniker: "test-moniker");
      when(remoteUserSource.getAccount(any))
          .thenAnswer((_) => Future.value(remoteAccount));

      await repository.refreshAccount();

      verifyInOrder([
        localUserSource.getAccount(),
        remoteUserSource.getAccount(account.address),
        localUserSource.saveAccount(remoteAccount),
      ]);
    });
  });

  test('accountStream emits correct events', () async {
    final account = MooncakeAccount.local("address");
    final controller = StreamController<MooncakeAccount>();

    when(localUserSource.accountStream).thenAnswer((_) => controller.stream);

    final stream = repository.accountStream;
    expectLater(
        stream,
        emitsInOrder([
          account,
          account.copyWith(moniker: "test"),
          account.copyWith(name: "John")
        ]));

    controller.add(account);
    controller.add(account.copyWith(moniker: "test"));
    controller.add(account.copyWith(name: "John"));
    controller.close();
  });

  test('fundAccount performs correct calls', () async {
    final account = MooncakeAccount.local("address");
    when(remoteUserSource.fundAccount(any))
        .thenAnswer((_) => Future.value(null));

    await repository.fundAccount(account);

    verify(remoteUserSource.fundAccount(account)).called(1);
  });

  test('saveAuthenticationMethod performs correct calls', () async {
    final method = PasswordAuthentication(hashedPassword: "password");
    when(localUserSource.saveAuthenticationMethod(any))
        .thenAnswer((_) => Future.value(null));

    await repository.saveAuthenticationMethod(method);

    verify(localUserSource.saveAuthenticationMethod(method)).called(1);
  });

  test('getAuthenticationMethod performs correct calls', () async {
    final method = PasswordAuthentication(hashedPassword: "password");
    when(localUserSource.getAuthenticationMethod())
        .thenAnswer((_) => Future.value(method));

    final result = await repository.getAuthenticationMethod();
    expect(result, equals(method));

    verify(localUserSource.getAuthenticationMethod()).called(1);
  });

  test('deleteData performs correct calls', () async {
    when(localUserSource.wipeData()).thenAnswer((_) => Future.value(null));

    await repository.deleteData();

    verify(localUserSource.wipeData()).called(1);
  });
}
