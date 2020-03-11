import 'dart:async';

import 'package:flutter/widgets.dart';

/// Contains all the localized texts that appear inside the application.
class PostsLocalizations {
  static PostsLocalizations of(BuildContext context) {
    return Localizations.of<PostsLocalizations>(
      context,
      PostsLocalizations,
    );
  }

  String get appTitle => "Mooncake";
  String get splashLoadingData => "Loading data...";

  // Login
  String get createAccountButtonText => "Create account";
  String get alreadyHaveMnemonicButtonText => "I already have a mnemonic";

  String get accountCreatedPopupTitleFirstRow => "The account";
  String get accountCreatedPopupTitleSecondRow => "Has been created";
  String get accountCreatedPopupText => "You can backup your phrase later";
  String get accountCreatedPopupMainButtonText => "Go to Mooncake";
  String get accountCreatedPopupBackupButtonText => "Backup mnemonic phrase";

  String get creatingAccountPopupTitle => "Creating account";
  String get creatingAccountText => "This might take a while...";

  // Mnemonic generation screen
  String get createAccount => "Create account";
  String get generatingMnemonic => "Generating mnemonic";
  String get generatedMnemonicText =>
      "Here is your mnemonic code. Please write it down on a piece of paper.";
  String get mnemonicWritten => "I've written down the mnemonic phrase";

  // Mnemonic recover screen
  String get mnemonicRecoverInstructions =>
      "Write below your mnemonic code, space separated:";
  String get mnemonicHint => "Mnemonic";
  String get recoverAccount => "Recover account";
  String get invalidMnemonic => "Invalid mnemonic";
  String get recoveringPopupTitle => "Recovering account...";
  String get recoveringPopupText =>
      "Your account is being recovered. This operation might take a while, please wait.";
  String get recoverPopupErrorTitle => "Error while recovering the account";

  // Main screen
  String get allPostsTabTitle => "Posts";
  String get likedPostsTabTitle => "Liked posts";
  String get notificationsTabTitle => "Notifications";
  String get yourAccountTabTitle => "Your account";
  String get signOut => "Sign out";
  String get floatingButtonTip => "Create post";
  String get loadingPosts => "Loading posts";
  String get postActionsButtonCaption => "See post actions";

  // Syncing
  String get syncingActivities => "Syncing activities...";
  String get fetchingPosts => "Checking for new posts...";
  String get syncErrorTitle => "Syncing error";
  String get syncErrorDesc =>
      "An error has verified when syncing the posts to the chain:";
  String get syncErrorCopied => "Sync error copied to clipboard";

  // Create post screen
  String get createPost => "Create post";
  String get newPostHint => "What's going on?";
  String get emptyPostError => "Empty message";
  String get saveChanges => "Save changes";
  String get savingPost => "Saving post";
  String get commentsEnabledTip => "Comments will be enabled - Tap to disable";
  String get commentsDisabledTip =>
      "Comments will be disabled - Tap to enabled them";
  String get cameraTip => "Take a picture using the camera";
  String get galleryTip => "Select an image from the gallery";

  // Notifications screen
  String get allNotificationsTabTitle => "All";
  String get mentionsNotificationsTabTitle => "Mentions";
  String get notificationHasCommentedText => "commented:";
  String get notificationAddedReaction => "added a reaction:";
  String get notificationLikedYourPost => "liked your post";
  String get notificationTaggedYou => "tagged you in a post";
  String get notificationMentionedYou => "mentioned you in a post:";
  String get noNotifications => "No notifications here, you're all done! 🎉";

  // Account screen
  String get accountPageTitle => "Welcome to your future account page";
  String get accountPageText => "We do not support accounts yet, but you can always click on the wallet option inside the app bar to visualize your wallet";

  // Post details
  String get postDetailsTitle => "Post details";
  String get loadingPost => "Loading post";
  String get post => "Post";
  String get commentHint => "Comment";
  String get newComment => "New comment";
  String get commentsDisabled => "Comments disabled by the post owner";
  String commentsTabLabel(int comments) => "Comments $comments";
  String reactionsTabLabel(int reactions) => "Reactions $reactions";
}

class FlutterBlocLocalizationsDelegate
    extends LocalizationsDelegate<PostsLocalizations> {
  @override
  Future<PostsLocalizations> load(Locale locale) =>
      Future(() => PostsLocalizations());

  @override
  bool shouldReload(FlutterBlocLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains("en");
}
