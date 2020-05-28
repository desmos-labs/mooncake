import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/repositories/user/user_repository_impl.dart';

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

  test('getMnemonic', () async {
    final mnemonic = ["mnemonic"];
    when(localUserSource.getMnemonic())
        .thenAnswer((_) => Future.value(mnemonic));

    final result = await repository.getMnemonic();
    expect(result, equals(mnemonic));

    verify(localUserSource.getMnemonic()).called(1);
  });

  test('getWallet', () async {
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
      when(localUserSource.getAccount())
          .thenAnswer((realInvocation) => Future.value(null));

      final result = await repository.getAccount();
      expect(result, isNull);

      verifyInOrder([
        localUserSource.getAccount(),
        localUserSource.getAccount(),
      ]);
    });

    test('when account exists locally', () async {
      final account = MooncakeAccount.local("address");
      when(localUserSource.getAccount())
          .thenAnswer((_) => Future.value(account));

      final remoteAccount = account.copyWith(moniker: "test-moniker");
      when(remoteUserSource.getAccount(any))
          .thenAnswer((_) => Future.value(remoteAccount));

      when(localUserSource.saveAccount(any))
          .thenAnswer((_) => Future.value(null));

      final result = await repository.getAccount();
      // The last call will be to the local source
      expect(result, equals(account));

      verifyInOrder([
        localUserSource.getAccount(),
        remoteUserSource.getAccount(account.address),
        localUserSource.saveAccount(remoteAccount),
        localUserSource.getAccount(),
      ]);
    });
  });
}
