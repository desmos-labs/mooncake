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
          postId: message.data['post_id'] as String,
          user: User.fromAddress(message.data['post_creator'] as String),
          comment: message.data['post_message'] as String,
          date: DateTime.now(),
          title: message.notification?.title,
          body: message.notification?.body,
        );

      case NotificationTypes.REACTION:
        return PostReactionNotification(
          postId: message.data['post_id'] as String,
          user: User.fromAddress(message.data['post_reaction_owner'] as String),
          date: DateTime.now(),
          reaction: message.data['post_reaction_value'] as String,
          title: message.notification?.title,
          body: message.notification?.body,
        );

      case NotificationTypes.TRANSACTION_SUCCESS:
        return TxSuccessfulNotification(
          date: DateTime.now(),
          txHash: message.data['tx_hash'] as String,
        );

      case NotificationTypes.TRANSACTION_FAIL:
        return TxFailedNotification(
          date: DateTime.now(),
          txHash: message.data['tx_hash'] as String,
          error: message.data['tx_error'] as String,
        );

      // TODO: Add other types

      default:
        return null;
    }
  }
}
