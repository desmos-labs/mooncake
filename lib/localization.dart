import 'dart:async';

import 'package:flutter/material.dart';

class FlutterBlocLocalizations {
  static FlutterBlocLocalizations of(BuildContext context) {
    return Localizations.of<FlutterBlocLocalizations>(
      context,
      FlutterBlocLocalizations,
    );
  }

  String get appTitle => "Dwitter";
  String get posts => "Posts";
  String get stats => "Stats";

  String get editPost => "Edit post";
  String get createPost => "Create post";
  String get newPostHint => "New post";
  String get emptyPostError => "Empty message";
  String get saveChanges => "Save changed";
}

class FlutterBlocLocalizationsDelegate
    extends LocalizationsDelegate<FlutterBlocLocalizations> {
  @override
  Future<FlutterBlocLocalizations> load(Locale locale) =>
      Future(() => FlutterBlocLocalizations());

  @override
  bool shouldReload(FlutterBlocLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains("en");
}