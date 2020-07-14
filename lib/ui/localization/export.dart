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

  // Loading screen
  String get splashLoadingData => "Loading data...";

  // Generic
  String get dismiss => "Dismiss";

  // Login
  String get createAccountButtonText => "Create Account";
  String get alreadyHaveMnemonicButtonText => "I Have A Written Mnemonic";
  String get useMnemonicBackup => "Use Mnemonic Backup";
  String get accountCreatedPopupTitleFirstRow => "The account";
  String get accountCreatedPopupTitleSecondRow => "Has been created";
  String get accountCreatedPopupText => "You can backup your phrase later";
  String get accountCreatedPopupMainButtonText => "Go to Mooncake";
  String get accountCreatedPopupBackupButtonText => "Backup mnemonic phrase";
  String get creatingAccountPopupTitle => "Creating account";
  String get creatingAccountText => "This might take a while...";
  String get termsDisclaimer => "By using this app you agree to our";
  String get terms => "Terms";
  String get and => "and";
  String get privacyPolicy => "Privacy Policy";

  // Recover screen
  String get recoverScreenTitle => "Recover mnemonic";

  // Recover mnemonic backup
  String get restoreMnemonicBackupScreenTitle => "Restore mnemonic backup";
  String get restoreMnemonicInstructions => """
This page allows you to restore a previously exported mnemonic backup.
In order to do so, please insert below your mnenonic backup text and the password
you used to encrypt it. Then press the below button to proceed.
""";
  String get restoreBackupFieldHint =>
      "Your backup here (it should end with an =)";
  String get errorBackupInvalid => "Invalid backup text";
  String get restorePasswordFieldHint => "Your encryption password";
  String get errorBackupPasswordWrong => "Wrong backup password";
  String get restoreButtonText => "Restore backup";

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
  String get biometricsEnableButton => "Enable";
  String get biometricsUsePasswordButton => "Use text password instead";
  String get biometricsReason => "Authenticate into Mooncake";

  // Password screen
  String get passwordTitle => "Set password";
  String get passwordBody => """
Due to security reasons, we require you to input a password if you will ever
want to recover your mnemonic phrase from within the application later on.
Please note that if you lose this password you will be required to enter
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

  // Security login screen
  String get viewMnemonic => "View mnemonic";
  String get securityLoginText => """
In order to prevent any unwanted access to your mnemonic phrase, you are
required to log in using the authentication method you have previously set
during the the first login into the app.
""";
  String get securityLoginWarning => """
Please note that your mnemonic should never be shown to anyone, and you should
see it only once when backing it up on a piece of paper. Allowing anyone to
see your mnemonic will most surely end in them stealing your account and all
your funds so proceed with caution.
""";
  String get securityLoginBiometrics => """
If you understand the risks of viewing your mnemonic, please select the
checkbox below and tap the button to start the authentication process.
""";
  String get securityLoginPassword => """
If you understand the risks of viewing your mnemonic, please select the
checkbox below, insert your password and press the button to view it.
""";
  String get understoodMnemonicDisclaimer =>
      "I understand the consequences of viewing my mnemonic.";

  // Mnemonic export
  String get exportMnemonic => "Export mnemonic";
  String get exportMnemonicDialogTitle => "Exporting mnemonic";
  String get exportMnemonicDialogText => """
In order to export your mnemonic properly, we need a password with which it
will be encrypted for security reasons. Please insert below such passwords
that you will also be required later when importing it.
""";
  String get exportMnemonicDialogPasswordHint => "Encryption password";
  String get exportMnemonicDialogCancelButton => "Cancel";
  String get exportMnemonicDialogExportButton => "Export";
  String get mnemonicExportScreenText => """
Following is your mnemonic encrypted data. You can export this data whenever
you want, even sending it to a friend of yours for backup, if you have used
a strong enough password. If you would like to share it somewhere, click on the
Share button below""";
  String get mnemonicExportShareButton => "Share";
  String get mnemonicExportShareText =>
      "Hey, here is my encrypted mnemonic for Mooncake! Please keep it safe!";

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
  String get editAccountOption => "Edit account";
  String get viewMnemonicOption => "View mnemonic";
  String get logoutOption => "Logout";

  // Post item
  String likesCount(int count) => "$count likes";

  // Post actions popup
  String get postActionsPopupTitle => "Post actions";
  String get postActionReportPost => "Report post";
  String get postActionHide => "Hide post";
  String get postActionBlockUser => "Block user";

  // Report popup
  String get reportPopupTitle => "What's wrong with this post?";
  String get reportPopupSpam => "It's spam";
  String get reportPopupSexuallyInappropriate => "It's sexually inappropriate";
  String get reportPopupScamMisleading => "It's scam or misleading";
  String get reportPopupViolentProhibited =>
      "It's violent or prohibited content";
  String get reportPopupOther => "Other";
  String get reportPopupEditBotHint => "Write something (optional)";
  String get reportPopupBlockUser => "Also block the user";
  String get reportPopupSubmit => "Submit";

  // Block user popup
  String get blockDialogTitle => "Block user?";
  String blockDialogText(String screenName) =>
      "By blocking $screenName you will no longer see his posts. "
      "Would you like to continue?";
  String get blockDialogCancelButton => "Cancel";
  String get blockDialogBlockButton => "Block";

  // Syncing
  String get syncingActivities => "Syncing activities to the chain";
  String get syncErrorTitle => "Syncing error";
  String get syncErrorDesc =>
      "An error has verified when syncing the posts to the chain:";
  String get syncErrorCopyButton => "Copy error";
  String get syncErrorCopied => "Sync error copied to clipboard";
  String get syncSuccessTitle => "Transaction sent";
  String syncSuccessBody(String txHash) =>
      "A transaction with hash $txHash has been sent to the chain";
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

  // Poll visualization
  String votes(int count) => "$count votes";
  String pollEndOn(String date) => "Poll will end on $date";
  String get finalResults => "Final results";

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
  String get editAccountButton => "Edit your account";
  String get saveAccountButton => "Save";
  String get saveAccountErrorPopupTitle => "Account saving error";
  String get saveAccountErrorPopupBody => """
An error has verified while saving your account.
Please try later.
""";

  String get chooseImageSourceTitle => "Choose where to pick the image from";
  String get chooseGalleryOption => "Gallery";
  String get chooseCameraOption => "Camera";

  // Edit account
  String get editAccountScreenTitle => "Edit account";
  String get dtagLabel => "DTag";
  String get monikerLabel => "Moniker";
  String get bioLabel => "Bio";
  String get errorDTagInvalid => """
DTag must be 3 - 20 characters lsong and contain only [a-z 0-9 _]
""";
  String get errorMonikerInvalid => """
Moniker must be 3 - 20 characters long.
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

  // mnemonic backup phrase
  String get mnemonicBackupBody1 => 'Hi,';
  String get mnemonicBackupBody2 => """
Glad to see you here,
One of the most important steps you can take to secure your account is to backup your Mnemonic Phrase.
  """;
  String get mnemonicBackupButton => "Backup phrase";
  String get mnemonicRemindMeLaterButton => "Remind me later";
  String get mnemonicDoNotShowAgainButton => "Do not show this popup again";
  String get mnemonicViewBody1 =>
      "Please write down and save your mnemonic phrase, It's the ";
  String get mnemonicViewBody2 => "ONLY WAY";
  String get mnemonicViewBody3 => " to restore your account";
  String get mnemonicBackupWrittenConfirm => "I have written them down";
  String get mnemonicWrittenConfirmation => "We'll confirm on the next screen";
  String get mnemonicCopy => "copy";
  String get mnemonicConfirmPhrase => "Confirm Phrase";
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
