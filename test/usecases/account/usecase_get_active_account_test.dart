import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:test/test.dart';

import 'common.dart';

void main() {
  UserRepository repository;
  GetActiveAccountUseCase usecase;

  setUp(() {
    repository = UserRepositoryMock();
    usecase = GetActiveAccountUseCase(userRepository: repository);
  });

  test('single performs correct calls', () async {
    final account = MooncakeAccount.local('address');
    when(repository.getActiveAccount())
        .thenAnswer((_) => Future.value(account));

    final result = await usecase.single();
    expect(result, equals(account));

    verify(repository.getActiveAccount()).called(1);
  });

  test('stream performs correct calls', () {
    final account = MooncakeAccount.local('address');

    final controller = StreamController<MooncakeAccount>();
    when(repository.activeAccountStream).thenAnswer((_) => controller.stream);

    final stream = usecase.stream();
    expectLater(
        stream,
        emitsInOrder([
          account,
          account.copyWith(moniker: 'test'),
        ]));

    controller.add(account);
    controller.add(account.copyWith(moniker: 'test'));
    controller.close();

    verify(repository.activeAccountStream).called(1);
  });
}
