import 'package:meta/meta.dart';
import 'package:mooncake/entities/notifications/notification.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Implementation of [NotificationsRepository].
class NotificationsRepositoryImpl extends NotificationsRepository {
  final RemoteNotificationsSource _remoteSource;
  final LocalNotificationsSource _localSource;

  NotificationsRepositoryImpl({
    @required RemoteNotificationsSource remoteNotificationsSource,
    @required LocalNotificationsSource localNotificationsSource,
  })  : assert(remoteNotificationsSource != null),
        assert(localNotificationsSource != null),
        _remoteSource = remoteNotificationsSource,
        _localSource = localNotificationsSource {
    // Listen for remote notifications and save them locally
    _remoteSource.notificationsStream.listen((notification) async {
      await _localSource.saveNotification(notification);
    });
  }

  @override
  Future<List<NotificationData>> getNotifications() {
    return _localSource.getNotifications();
  }

  @override
  Stream<NotificationData> get liveNotificationsStream {
    return _localSource.liveNotificationsStream;
  }
}
