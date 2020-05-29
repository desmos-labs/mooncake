import 'package:mooncake/entities/entities.dart';

/// Represents the source that should be used to fetch the notifications
/// from the device.
abstract class LocalNotificationsSource {
  /// Returns the list of all the notifications related to the user.
  Future<List<NotificationData>> getNotifications();

  /// Returns a [Stream] that emits all the new notifications
  /// as soon as they are created.
  Stream<NotificationData> get notificationsStream;

  /// Saves the given [notification] inside the local source.
  Future<void> saveNotification(NotificationData notification);
}
