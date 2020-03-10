import 'package:mooncake/entities/entities.dart';

import 'models/models.dart';

export 'models/models.dart';

/// Allows to easily convert any [FcmMessage] to the proper
/// [NotificationData] instance.
class NotificationConverter {
  /// Converts the given [message] to the proper [NotificationData] instance.
  NotificationData convertFcmMessage(FcmMessage message) {
    switch (message.type) {
      case "comment":
        return PostCommentNotification(
          postId: message.data["post_id"],
          user: message.data["post_creator"],
          comment: message.data["post_message"],
          date: DateTime.now(),
          title: message.notification?.title,
          body: message.notification?.body,
        );

      case "mention":
        return PostMentionNotification(
          postId: message.data["post_id"],
          user: message.data["post_creator"],
          date: DateTime.now(),
          text: message.data["post_message"],
          title: message.notification?.title,
          body: message.notification?.body,
        );

      // TODO: Add other types

      default:
        return null;
    }
  }
}
