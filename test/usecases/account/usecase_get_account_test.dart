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
    when(repository.getAccount()).thenAnswer((_) => Future.value(account));

    final result = await getAccountUseCase.single();
    expect(result, equals(account));

    verify(repository.getAccount()).called(1);
  });

  test('stream performs correct calls', () async {
    final account = MooncakeAccount.local("address");

    final controller = StreamController<MooncakeAccount>();
    when(repository.accountStream).thenAnswer((_) => controller.stream);

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

    verify(repository.accountStream).called(1);
  });
}
