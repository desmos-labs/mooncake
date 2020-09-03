import 'dart:async';

import 'package:meta/meta.dart';
import 'package:mooncake/entities/notifications/notification.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sembast/sembast.dart';

/// Implementation of [LocalNotificationsSource].
class LocalNotificationsSourceImpl extends LocalNotificationsSource {
  final Database _database;
  final _store = StoreRef.main();

  final _liveNotificationsController = BehaviorSubject<NotificationData>();

  /// Public constructor
  LocalNotificationsSourceImpl({
    @required Database database,
  })  : assert(database != null),
        _database = database;

  @override
  Stream<NotificationData> get liveNotificationsStream {
    return _liveNotificationsController.stream;
  }

  @override
  Stream<NotificationData> get storedNotificationsStream {
    final finder = Finder(
      sortOrders: [SortOrder(NotificationData.DATE_FIELD, false)],
    );
    return _store
        .query(finder: finder)
        .onSnapshots(_database)
        .expand((element) => element)
        .map((record) => NotificationData.fromJson(
              record.value as Map<String, dynamic>,
            ));
  }

  @override
  Future<List<NotificationData>> getNotifications() async {
    final finder = Finder(
      sortOrders: [SortOrder(NotificationData.DATE_FIELD, false)],
    );

    final records = await _store.find(_database, finder: finder);
    return (records ?? [])
        .map((record) => NotificationData.fromJson(
              record.value as Map<String, dynamic>,
            ))
        .toList();
  }

  @override
  Future<void> saveNotification(NotificationData notification) async {
    final data = notification.asJson();
    await _store.record(notification.stringDate).put(_database, data);
    _liveNotificationsController.add(notification);
  }
}
