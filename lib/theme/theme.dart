import 'package:flutter/material.dart';

/// Allows to easily retrieve the data of the application theme
class PostsTheme {
  static Color get primaryColor => theme.primaryColor;
  static Color get accentColor => theme.accentColor;

  static Color get textColor => Colors.white;
  static Color get textColorLight => Colors.grey[500];

  static ThemeData get theme {
    return ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.dark,
      primaryColor: Colors.lightBlue[800],
      accentColor: Colors.cyan[600],

      // Define the default font family.
      fontFamily: 'Roboto',
      textTheme: TextTheme(
        body1: TextStyle(color: textColor),
      ),
    );
  }
}
