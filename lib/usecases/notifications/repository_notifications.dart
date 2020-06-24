import 'package:mooncake/entities/entities.dart';

/// Represents the repository that should be used when dealing with
/// user notifications.
abstract class NotificationsRepository {
  /// Returns the list of notifications that are
  /// currently stored inside the device.
  Future<List<NotificationData>> getNotifications();

  /// Returns a Stream that emits all the new notifications
  /// when they are created.
  Stream<NotificationData> get liveNotificationsStream;
}
