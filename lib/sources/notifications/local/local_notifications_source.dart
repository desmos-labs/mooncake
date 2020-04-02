import 'dart:async';

import 'package:meta/meta.dart';
import 'package:mooncake/entities/notifications/notification.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:sembast/sembast.dart';

/// Implementation of [LocalNotificationsSource].
class LocalNotificationsSourceImpl extends LocalNotificationsSource {
  final Database _database;
  final _store = StoreRef.main();

  /// Public constructor
  LocalNotificationsSourceImpl({
    @required Database database,
  })  : assert(database != null),
        this._database = database;

  @override
  Stream<NotificationData> get notificationsStream {
    return _store
        .stream(_database)
        .map((record) => NotificationData.fromJson(record.value));
  }

  @override
  Future<List<NotificationData>> getNotifications() async {
    final finder = Finder(
      sortOrders: [SortOrder(NotificationData.DATE_FIELD, false)],
    );

    final records = await _store.find(_database, finder: finder);
    return (records ?? [])
        .map((record) => NotificationData.fromJson(record.value))
        .toList();
  }

  @override
  Future<void> saveNotification(NotificationData notification) async {
    await _store
        .record(notification.stringDate)
        .put(_database, notification.asJson());
  }
}
