import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/account/export.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'common.dart';

void main() {
  UserRepository repository;
  GetAccountUseCase getAccountUseCase;

  setUp(() {
    repository = UserRepositoryMock();
    getAccountUseCase = GetAccountUseCase(userRepository: repository);
  });

  test('single performs correct calls', () async {
    final account = MooncakeAccount.local("address");
    when(repository.getAccount(account.address))
        .thenAnswer((_) => Future.value(account));

    final result = await getAccountUseCase.single(account.address);
    expect(result, equals(account));

    verify(repository.getAccount(account.address)).called(1);
  });

  test('stream performs correct calls', () {
    final account = MooncakeAccount.local("address");

    final controller = StreamController<MooncakeAccount>();
    when(repository.activeAccountStream).thenAnswer((_) => controller.stream);

    final stream = getAccountUseCase.stream();
    expectLater(
        stream,
        emitsInOrder([
          account,
          account.copyWith(moniker: "test"),
        ]));

    controller.add(account);
    controller.add(account.copyWith(moniker: "test"));
    controller.close();

    verify(repository.activeAccountStream).called(1);
  });

  test('getActiveAccount performs correct calls', () async {
    final account = MooncakeAccount.local("address");
    when(repository.getActiveAccount())
        .thenAnswer((_) => Future.value(account));

    final result = await getAccountUseCase.getActiveAccount();
    expect(result, equals(account));

    verify(repository.getActiveAccount()).called(1);
  });

  test('all performs correct calls', () async {
    final account = MooncakeAccount.local("address");
    when(repository.getAccounts()).thenAnswer((_) => Future.value([account]));

    final result = await getAccountUseCase.all();
    expect(result, equals([account]));

    verify(repository.getAccounts()).called(1);
  });
}
