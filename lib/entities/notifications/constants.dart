/// The [NotificationTypes] contains the definition of all the types that a
/// notification can have.
///
/// The type should be specified inside the `data` object of a Firebase
/// notification. The value should be associated with the `type` key.
///
/// More information about the Firebase data structure can be found here:
/// https://firebase.google.com/docs/cloud-messaging/concept-options#data_messages
///
/// Example of a notification having type `comment`:
/// ```json
/// {
///   "data": {
///     "type": "comment"
///     ...
///   }
/// }
/// ```
class NotificationTypes {
  static const COMMENT = 'comment';
  static const LIKE = 'like';
  static const REACTION = 'reaction';
  static const MENTION = 'mention';
  static const TAG = 'tag';

  static const TRANSACTION_SUCCESS = 'transaction_success';
  static const TRANSACTION_FAIL = 'transaction_fail';
}

/// The [NotificationActions] contains the definition of all the possible
/// actions that a notification can have and are supported from the application.
///
/// The action should be specified inside the `data` object of a Firebase
/// notification. The value should be associated with `action` key.
///
/// More information about the Firebase data structure can be found here:
/// https://firebase.google.com/docs/cloud-messaging/concept-options#data_messages
///
/// Example of a notification having action `showPost`:
/// ```json
/// {
///   "data": {
///     "action": "showPost",
///     ...
///   }
/// }
/// ```
class NotificationActions {
  static const ACTION_SHOW_POST = 'showPost';
}
