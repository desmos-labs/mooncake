import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PostsLocalizations {
  final Locale locale;

  PostsLocalizations(this.locale);

  static const LocalizationsDelegate<PostsLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const LocalizationsDelegate<PostsLocalizations> delegateTest =
      _AppLocalizationsDelegate(test: true);

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static PostsLocalizations of(BuildContext context) {
    return Localizations.of<PostsLocalizations>(context, PostsLocalizations);
  }

  Map<String, String> _localizedStrings = {};

  Future<bool> load() async {
    // Load the language JSON file from the "lang" folder
    var jsonString = await rootBundle.loadString(
        'lib/ui/localization/languages/${locale.languageCode}.json');
    var jsonMap = json.decode(jsonString) as Map<String, dynamic>;

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  Future<PostsLocalizations> loadTest(Locale locale) async {
    return PostsLocalizations(locale);
  }

  // This method will be called from every widget which needs a localized text
  String translate(String key) {
    var value = _localizedStrings[key];
    return value ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<PostsLocalizations> {
  final bool test;

  const _AppLocalizationsDelegate({this.test = false});

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return ['en', 'sk'].contains(locale.languageCode);
  }

  @override
  Future<PostsLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    var localizations = PostsLocalizations(locale);
    test ? await localizations.loadTest(locale) : await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
