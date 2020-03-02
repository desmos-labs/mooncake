import 'package:mooncake/entities/entities.dart';

/// Represents the remote source that should be used in order
/// to get the notifications from the server.
abstract class RemoteNotificationsSource {
  /// Returns the list of all the notifications related to the user.
  Future<List<NotificationData>> getNotifications();

  /// Returns a [Stream] that emits all the new notifications
  /// as soon as they are created.
  Stream<NotificationData> getNotificationsStream();

  Stream<FcmMessage> get foregroundStream;

  Stream<FcmMessage> get backgroundStream;
}
