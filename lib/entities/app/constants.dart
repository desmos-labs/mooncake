/// Contains the application-wide constants.
class Constants {
  /// Subspace that should be used to create and read posts
  static const SUBSPACE = "mooncake";

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
}
