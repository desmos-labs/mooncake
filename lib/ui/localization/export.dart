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
  String get appPhrase => "Hello, dreamer!";
  String get appDescription => "Welcome to a new world of decentralized social networks";
  String get loadingData => "Loading data...";

  String get allPosts => "Posts";
  String get yourAccount => "Your account";
  String get signOut => "Sign out";

  String get editPost => "Edit post";
  String get createPost => "Create post";
  String get newPostHint => "New post";
  String get emptyPostError => "Empty message";
  String get saveChanges => "Save changes";
  String get savingPost => "Saving post";

  String get accountTitle => "Your account";
  String get yourAddress => "Your address:";

  String get post => "Post";

  String get newComment => "New comment";
  String get commentHint => "Comment";
  String get commentsDisabled => "Comments disabled by the post owner";

  String get syncingActivities => "Syncing activities...";
  String get fetchingPosts => "Checking for new posts...";

  String get recoverFromMnemonic => "Recover from mnemonic";
  String get generateNewAccount => "Generate new account";
  String get mnemonicRecoverInstructions =>
      "Write here your mnemonic code, space separated";
  String get mnemonicHint => "Mnemonic";
  String get recoverAccount => "Recover account";
  String get invalidMnemonic => "Invalid mnemonic";

  String get createAccount => "Create account";
  String get generatingMnemonic => "Generating mnemonic";
  String get generatedMnemonicText =>
      "Here is your mnemonic code. Please write it down on a piece of paper.";
  String get mnemonicWritten => "I've written down the mnemonic phrase";
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
