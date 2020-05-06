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

  String get appName => "Mooncake";
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

  // Recover screen
  String get recoverScreenTitle => "Recover mnemonic";

  // Mnemonic recover screen
  String get recoverAccountInstructions => "Please enter your mnemonic phrase"
      " in order and make sure your mnemonic is written correctly";
  String get recoverAccount => "Recover account";
  String get recoverAccountContinueButton => "Continue";
  String get recoverAccountInvalidMnemonic => "This mnemonic does not seem "
      "valid. Please check it again.";

  // Biometrics screen
  String get biometricsTitle => "Biometric authentication";
  String get biometricsBody => """
Please note that the biometric authentication will be paired only to this\
device and any fingerprint or face that has been set to unlock your device\
can be used to access your account on this application
  """;
  String get savingBiometricsTitle => "Saving biomentrics";
  String get savingBiometricsBody => "This might take a while";

  // Password screen
  String get passwordTitle => "Set password";
  String get passwordBody => """
Due to security reasons, we require you to input a password if you will ever
want to recover your mnemonic phrase from within the application later on.
Please note that if you loose this password you will be required to enter 
your mnemonic from scratch in the case of a future recovery.
""";
  String get passwordHint => "Password";
  String get passwordCaption => "* at least 6 characters in length";
  String get passwordSaveButton => "Save";
  String get passwordSecurityLow => "Low";
  String get passwordSecurityMedium => "Medium";
  String get passwordSecurityHigh => "High";
  String get passwordShowPasswordButton => "Show password";
  String get passwordHidePasswordButton => "Hide password";
  String get savingPasswordTitle => "Saving password";
  String get savingPasswordBody => "This might take a while";

  String get biometricsEnableButton => "Enable";
  String get biometricsUsePasswordButton => "Use text password instead";
  String get biometricsReason => "Authenticate into Mooncake";

  // Main screen
  String get refreshButtonText => "New posts available. Tap to refresh";
  String get allPostsTabTitle => "Posts";
  String get likedPostsTabTitle => "Liked posts";
  String get notificationsTabTitle => "Notifications";
  String get yourAccountTabTitle => "Your account";
  String get signOut => "Sign out";
  String get floatingButtonTip => "Create post";
  String get loadingPosts => "Loading posts";
  String get noPostsYet => """
Looks a little empty here.
What about adding some content?
""";
  String get postActionsButtonCaption => "See post actions";

  // Action bar
  String get brightnessButtonTooltip => "Brightness";
  String get walletButtonTooltip => "Wallet";
  String get logoutButtonTooltip => "Logout";

  // Post item
  String likesCount(int count) => "$count likes";

  // Post actions popup
  String get postActionsPopupTitle => "Post actions";
  String get postActionReport => "Report";
  String get postActionHide => "Hide post";

  // Report popup
  String get reportPopupTitle => "What's wrong with this post?";
  String get reportPopupSpam => "It's spam";
  String get reportPopupSexuallyInappropriate => "It's sexually inappropriate";
  String get reportPopupScamMisleading => "It's scam or misleading";
  String get reportPopupViolentProhibited =>
      "It's violent or prohibited content";
  String get reportPopupOther => "Other";
  String get reportPopupEditBotHint => "Write something (optional)";
  String get reportPopupSubmit => "Submit";

  // Syncing
  String get syncingActivities => "Syncing activities to the chain";
  String get syncErrorTitle => "Syncing error";
  String get syncErrorDesc =>
      "An error has verified when syncing the posts to the chain:";
  String get syncErrorCopyButton => "Copy error";
  String get syncErrorCopied => "Sync error copied to clipboard";
  String get syncSuccessTitle => "Transaction sent";
  String syncSuccessBody(String txHash) =>
      "A transaction with hash %s has been sent to the chain";
  String get syncSuccessBrowseButton => "Browse transaction";

  // Create post screen
  String get newPostHint => "What's going on?";
  String get createPostEnableCommentsButtonHint =>
      "Comments to this post will be disabled. Tap to enable them";
  String get createPostDisableCommentsButtonHint =>
      "Comments to this post will be enabled. Tap to disable them";
  String get createPostCreatePollButtonHint => "Add poll";
  String get createPostCancelButton => "Cancel";
  String get createPostCreateButton => "Post";
  String get createPostHint => "What's on your mind?";
  String get cameraTip => "Take a picture using the camera";
  String get galleryTip => "Select an image from the gallery";
  String get savingPostPopupBody =>
      "The post will now be synced to the chain. This might take a while";
  String get savingPostPopupDontShow => "Don't show again";
  String get savingPostPopupOkButton => "OK";

  // Poll creation
  String get pollQuestionHint => "What do you want to ask?";
  String get pollOptionHint => "Choice";
  String get pollAddOptionButton => "Add option";
  String get pollEndDateText => "This poll will end on";
  String get pollDeleteOptionHint => "Delete option";

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
  String get accountScreenTitle => "Account";
  String get accountPageTitle => "Welcome to your future account page";
  String get accountPageText => """
We do not support accounts yet, but you can always click on the wallet option
inside the app bar to visualize your wallet
""";

  // Wallet screen
  String get walletScreenName => "Wallet";
  String get walletTitle => "Welcome to your wallet";
  String get walletBodyText => """
We do not support transactions history yet, but you can always see the current 
amount of tokens you own on the top of the page
""";
  String get emptyWalletTitle => "No tokens available";
  String get emptyWalletBody => """
You don't have any token yet. Ask someone to send you some, or request them
using our faucet to see them here.
""";

  // Post details
  String get postDetailsTitle => "Post details";
  String get loadingPost => "Loading post";
  String get post => "Post";
  String get commentHint => "Comment";
  String get newComment => "New comment";
  String get commentsDisabled => "Comments disabled by the post owner";
  String get noCommentsYet => """
Currently there are no comments to this post yet.
Be the first to add one!
""";
  String commentsTabLabel(int comments) => "Comments $comments";
  String get noReactionsYet => """
Currently there are no reactions to this post yet.
Be the first to add one!
""";
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
