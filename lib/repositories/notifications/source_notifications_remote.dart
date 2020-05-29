import 'package:mooncake/entities/entities.dart';

/// Represents the remote source that should be used in order
/// to get the notifications from the server.
abstract class RemoteNotificationsSource {
  /// Returns a [Stream] that emits all the new notifications
  /// as soon as they are created.
  Stream<NotificationData> get notificationsStream;

  /// Returns a [Stream] that emits only the notifications that are
  /// delivered to the device while the application is in the foreground.
  Stream<NotificationData> get foregroundStream;

  /// Returns a [Stream] that emits only the notifications that are
  /// delivered to the device while the application in in the background.
  Stream<NotificationData> get backgroundStream;
}
