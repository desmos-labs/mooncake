import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PostsLocalizations {
  final Locale locale;

  PostsLocalizations(this.locale);

  static const LocalizationsDelegate<PostsLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static PostsLocalizations of(BuildContext context) {
    return Localizations.of<PostsLocalizations>(context, PostsLocalizations);
  }

  Map<String, String> _localizedStrings;

  Future<bool> load() async {
    // Load the language JSON file from the "lang" folder
    String jsonString = await rootBundle
        .loadString('lib/ui/localization/lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap =
        json.decode(jsonString) as Map<String, dynamic>;

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  // This method will be called from every widget which needs a localized text
  String translate(String key) {
    return _localizedStrings[key];
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<PostsLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return ['en', 'sk'].contains(locale.languageCode);
  }

  @override
  Future<PostsLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    PostsLocalizations localizations = PostsLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// class PostsLocalizationss {

//   // Post item
//   String likesCount(int count) => "$count likes";

//   // Block user popup
//   String blockDialogText(String screenName) =>
//       "By blocking $screenName you will no longer see his posts. "
//       "Would you like to continue?";

//   // Syncing
//   String syncSuccessBody(String txHash) =>
//       "A transaction with hash $txHash has been sent to the chain";

//   String votes(int count) => "$count votes";

//   String pollEndOn(String date) => "Poll will end on $date";

//   String commentsTabLabel(int comments) => "Comments $comments";

//   String reactionsTabLabel(int reactions) => "Reactions $reactions";

// }
