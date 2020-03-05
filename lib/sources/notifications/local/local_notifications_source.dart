import 'dart:async';

import 'package:meta/meta.dart';
import 'package:mooncake/entities/notifications/notification.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';

/// Implementation of [LocalNotificationsSource].
class LocalNotificationsSourceImpl extends LocalNotificationsSource {
  final String _dbName;

  final store = StoreRef.main();
  final BehaviorSubject<NotificationData> _streamController =
      BehaviorSubject<NotificationData>();

  /// Public constructor
  LocalNotificationsSourceImpl({
    @required String dbName,
  })  : assert(dbName != null && dbName.isNotEmpty),
        this._dbName = dbName;

  Future<Database> get database async {
    final path = await getApplicationDocumentsDirectory();
    await path.create(recursive: true);
    return databaseFactoryIo.openDatabase(join(path.path, this._dbName));
  }

  @override
  Stream<NotificationData> get notificationsStream => _streamController.stream;

  @override
  Future<List<NotificationData>> getNotifications() async {
    final database = await this.database;
    final finder = Finder(
      sortOrders: [
        SortOrder(NotificationData.DATE_FIELD, false), // Descending date
      ],
    );

    final records = await store.find(database, finder: finder);
    return (records ?? [])
        .map((record) => NotificationData.fromJson(record.value))
        .toList();
  }

  @override
  Future<void> saveNotification(NotificationData notification) async {
    final database = await this.database;
    await store.record(notification.date).put(database, notification.asJson());
    _streamController.add(notification);
  }
}
