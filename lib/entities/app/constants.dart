import 'package:meta/meta.dart';

/// Contains the application-wide constants.
class Constants {
  /// Subspace that should be used to create and read posts
  static const SUBSPACE =
      "2bdf5932925584b9a86470bea60adce69041608a447f84a3317723aa5678ec88";

  /// Token denom that should be used to pay for fees
  static const FEE_TOKEN = "udaric";

  // Analytics constants
  static const EVENT_MNEMONIC_GENERATE = "mnemonic_generated";
  static const EVENT_ACCOUNT_RECOVERED = "account_recovered";
  static const EVENT_LOGOUT = "logout";
  static const EVENT_NAVIGATE_TO_SCREEN = "navigate_to_screen";
  static const EVENT_SAVE_POST = "save_post";
  static const EVENT_ADD_REACTION = "add_reaction";
  static const EVENT_REMOVE_REACTION = "remove_reaction";

  // Post creation
  static const POST_PARAM_OWNER = "owner";

  // Notifications
  static const NOTIFICATION_CHANNEL_POSTS = const NotificationChannel(
    id: "mooncake_posts",
    title: "Posts interactions",
    description: "Make sound and pop on a new post interaction",
  );
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
