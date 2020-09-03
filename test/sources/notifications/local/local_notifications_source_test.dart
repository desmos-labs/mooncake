import 'dart:io';

import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/sources/sources.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:test/test.dart';

void main() {
  Database database;
  LocalNotificationsSourceImpl source;

  setUp(() async {
    database =
        await databaseFactoryIo.openDatabase(DateTime.now().toIso8601String());
    source = LocalNotificationsSourceImpl(database: database);
  });

  tearDown(() async {
    File(database.path).deleteSync();
  });

  test('save works properly', () async {
    final not = TxSuccessfulNotification(date: DateTime.now(), txHash: '');
    await source.saveNotification(not);

    final count = await StoreRef.main().count(database);
    expect(count, equals(1));
  });

  test('notifications reading works properly', () async {
    final first = TxSuccessfulNotification(
      date: DateTime.fromMicrosecondsSinceEpoch(10000),
      txHash: 'hash1',
    );
    final second = TxSuccessfulNotification(
      date: DateTime.fromMicrosecondsSinceEpoch(20000),
      txHash: 'hash2',
    );

    final store = StoreRef.main();
    await store.addAll(database, [first.asJson(), second.asJson()]);
    expect(await store.count(database), equals(2));

    final result = await source.getNotifications();
    expect(result, equals([second, first]));
  });

  test('liveNotificationsStream emits valid data', () async {
    final first = TxSuccessfulNotification(
      date: DateTime.fromMicrosecondsSinceEpoch(10000),
      txHash: 'hash1',
    );
    final second = TxSuccessfulNotification(
      date: DateTime.fromMicrosecondsSinceEpoch(20000),
      txHash: 'hash2',
    );

    // ignore: unawaited_futures
    expectLater(
      source.liveNotificationsStream,
      emitsInOrder([first, second]),
    );

    await source.saveNotification(first);
    await source.saveNotification(second);
  });

  test('storedNotificationsStream returns valid data', () async {
    final first = TxSuccessfulNotification(
      date: DateTime.fromMicrosecondsSinceEpoch(10000),
      txHash: 'hash1',
    );
    final second = TxSuccessfulNotification(
      date: DateTime.fromMicrosecondsSinceEpoch(20000),
      txHash: 'hash2',
    );

    final store = StoreRef.main();
    await store.add(database, first.asJson());
    await store.add(database, second.asJson());

    await expectLater(
      source.storedNotificationsStream,
      emitsInOrder([second, first]),
    );
  });
}
