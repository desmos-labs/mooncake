import 'package:meta/meta.dart';

// DONTCOVER

/// Contains the application-wide constants.
class Constants {
  // Explorer
  static const EXPLORER = 'https://morpheus.desmos.network';

  // Subspace that should be used to create and read posts
  static const SUBSPACE =
      '2bdf5932925584b9a86470bea60adce69041608a447f84a3317723aa5678ec88';

  // Fees constants
  static const FEE_POST = 100000; // 0.10 per post/comment
  static const FEE_REACTION = 50000; // 0.05 per post reaction added/removed
  static const FEE_POLL_ANSWER = 50000; // 0.05 per poll answer
  static const FEE_ACCOUNT_EDIT = 200000; // 0.20 per account edit

  // Token denom that should be used to pay for fees
  static const FEE_TOKEN = 'udaric';

  // Analytics constants
  static const EVENT_ACCOUNT_RECOVERED = 'account_recovered';
  static const EVENT_LOGOUT = 'logout';
  static const EVENT_MNEMONIC_EXPORT = 'mnemonic_exported';
  static const EVENT_MNEMONIC_GENERATE = 'mnemonic_generated';
  static const EVENT_NAVIGATE_TO_SCREEN = 'navigate_to_screen';
  static const EVENT_REACTION_CHANGED = 'reaction_changed';
  static const EVENT_SAVE_POST = 'save_post';

  // Post creation
  static const POST_PARAM_OWNER = 'owner';

  // Notifications
  static const NOTIFICATION_CHANNEL_POSTS = NotificationChannel(
    id: 'mooncake_posts',
    title: 'Posts interactions',
    description: 'Make sound and pop on a new post interaction',
  );

  // Reactions
  static const LIKE_REACTION = '❤';
}

/// Contains the data of a notification channel (required for Android 8.0+).
class NotificationChannel {
  final String id;
  final String title;
  final String description;

  const NotificationChannel({
    @required this.id,
    @required this.title,
    @required this.description,
  });
}
