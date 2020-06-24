import 'package:mooncake/entities/entities.dart';

import 'models/models.dart';

export 'models/models.dart';

/// Allows to easily convert any [FcmMessage] to the proper
/// [NotificationData] instance.
class NotificationConverter {
  /// Converts the given [message] to the proper [NotificationData] instance.
  NotificationData convert(FcmMessage message) {
    switch (message.type) {
      case NotificationTypes.COMMENT:
        return PostCommentNotification(
          postId: message.data["post_id"],
          user: User.fromAddress(message.data["post_creator"]),
          comment: message.data["post_message"],
          date: DateTime.now(),
          title: message.notification?.title,
          body: message.notification?.body,
        );

      case NotificationTypes.COMMENT:
        return PostMentionNotification(
          postId: message.data["post_id"],
          user: User.fromAddress(message.data["post_creator"]),
          date: DateTime.now(),
          text: message.data["post_message"],
          title: message.notification?.title,
          body: message.notification?.body,
        );

      case NotificationTypes.REACTION:
        return PostReactionNotification(
          postId: message.data["post_id"],
          user: User.fromAddress(message.data["post_reaction_owner"]),
          date: DateTime.now(),
          reaction: message.data["post_reaction_value"],
          title: message.notification?.title,
          body: message.notification?.body,
        );

      case NotificationTypes.TRANSACTION_SUCCESS:
        return TxSuccessfulNotification(
          date: DateTime.now(),
          txHash: message.data["tx_hash"],
        );

      case NotificationTypes.TRANSACTION_FAIL:
        return TxFailedNotification(
          date: DateTime.now(),
          txHash: message.data["tx_hash"],
          error: message.data["tx_error"],
        );

    // TODO: Add other types

      default:
        return null;
    }
  }
}
