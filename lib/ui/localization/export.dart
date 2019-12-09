import 'dart:async';

import 'package:flutter/widgets.dart';

class PostsLocalizations {
  static PostsLocalizations of(BuildContext context) {
    return Localizations.of<PostsLocalizations>(
      context,
      PostsLocalizations,
    );
  }

  String get appTitle => "Dwitter";
  String get posts => "Posts";
  String get stats => "Stats";
  String get signOut => "Sign out";

  String get editPost => "Edit post";
  String get createPost => "Create post";
  String get newPostHint => "New post";
  String get emptyPostError => "Empty message";
  String get saveChanges => "Save changed";

  String get post => "Post";

  String get newComment => "New comment";
  String get commentHint => "Comment";
  String get commentsDisabled => "Comments disabled by the post owner";

  String get syncingActivities => "Syncing activities...";

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
