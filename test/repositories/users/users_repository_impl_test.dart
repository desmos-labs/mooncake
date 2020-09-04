import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/repositories/users/users_repository_impl.dart';

class LocalUsersSourceMock extends Mock implements LocalUsersSource {}

void main() {
  LocalUsersSource localUsersSource;
  UsersRepositoryImpl repository;

  setUp(() {
    localUsersSource = LocalUsersSourceMock();
    repository = UsersRepositoryImpl(localUsersSource: localUsersSource);
  });

  test('blockedUsersStream', () {
    final controller = StreamController<List<String>>();
    when(localUsersSource.blockedUsersStream)
        .thenAnswer((_) => controller.stream);

    final stream = repository.blockedUsersStream;
    expectLater(
        stream,
        emitsInOrder([
          [],
          ['1'],
          ['1', '2', '3']
        ]));

    controller.add([]);
    controller.add(['1']);
    controller.add(['1', '2', '3']);
    controller.close();
  });

  test('getBlockedUsers', () async {
    final value = ['first', 'second'];
    when(localUsersSource.getBlockedUsers())
        .thenAnswer((_) => Future.value(value));

    final result = await repository.getBlockedUsers();
    expect(result, equals(value));

    verify(localUsersSource.getBlockedUsers()).called(1);
  });

  test('blockUser', () async {
    final user = User.fromAddress('address');
    when(localUsersSource.blockUser(any)).thenAnswer((_) => Future.value(null));

    await repository.blockUser(user);

    verify(localUsersSource.blockUser(user)).called(1);
  });

  test('unblockUser', () async {
    final user = User.fromAddress('address');
    when(localUsersSource.unblockUser(any))
        .thenAnswer((_) => Future.value(null));

    await repository.unblockUser(user);

    verify(localUsersSource.unblockUser(user)).called(1);
  });
}
