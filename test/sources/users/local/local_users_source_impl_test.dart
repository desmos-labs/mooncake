import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/sources/sources.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_memory.dart';

void main() {
  Database database;
  LocalUsersSource source;

  setUp(() async {
    final factory = databaseFactoryMemory;
    database = await factory.openDatabase(DateTime.now().toIso8601String());
    source = LocalUsersSourceImpl(database: database);
  });

  test('getBlockedUsers returns empty list if empty', () async {
    final result = await source.getBlockedUsers();
    expect(result, isEmpty);
  });

  test('getBlockedUsers returns correct list', () async {
    final users = ['first', 'second'];
    await StoreRef.main()
        .record(LocalUsersSourceImpl.BLOCKED_USERS_KEY)
        .put(database, users);

    final stored = await source.getBlockedUsers();
    expect(stored, equals(users));
  });

  test('blockUser works properly', () async {
    expect(await source.getBlockedUsers(), isEmpty);

    await source.blockUser(User.fromAddress('first'));
    expect(await source.getBlockedUsers(), equals(['first']));

    await source.blockUser(User.fromAddress('second'));
    expect(await source.getBlockedUsers(), equals(['first', 'second']));
  });

  test('unblockUser works properly', () async {
    expect(await source.getBlockedUsers(), isEmpty);

    await source.blockUser(User.fromAddress('first'));
    await source.blockUser(User.fromAddress('second'));
    expect(await source.getBlockedUsers(), equals(['first', 'second']));

    await source.unblockUser(User.fromAddress('first'));
    expect(await source.getBlockedUsers(), equals(['second']));

    await source.unblockUser(User.fromAddress('second'));
    expect(await source.getBlockedUsers(), isEmpty);
  });
}
