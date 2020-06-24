import 'package:mooncake/entities/entities.dart';

/// Represents the source that should be used to fetch the notifications
/// from the device.
abstract class LocalNotificationsSource {
  /// Returns a [Stream] that emits all the new notifications
  /// as soon as they are created.
  Stream<NotificationData> get liveNotificationsStream;

  /// Returns a [Stream] that emits all the locally stored notifications
  /// each time a new one is stored.
  Stream<NotificationData> get storedNotificationsStream;

  /// Returns the list of all the notifications related to the user.
  Future<List<NotificationData>> getNotifications();

  /// Saves the given [notification] inside the local source.
  Future<void> saveNotification(NotificationData notification);
}
