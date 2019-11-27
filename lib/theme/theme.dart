import 'package:flutter/material.dart';

/// Allows to easily retrieve the data of the application theme
class PostsTheme {
  static Color get primaryColor => Colors.lightBlue[800];
  static Color get accentColor => Colors.cyan[600];

  static Color get textColor => Colors.white;
  static Color get textColorLight => Colors.grey[500];

  static EdgeInsets get postItemPadding => EdgeInsets.all(16);

  static ThemeData get theme {
    return ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      accentColor: accentColor,

      // Define the default font family.
      fontFamily: 'Roboto',
      textTheme: TextTheme(
        body1: TextStyle(color: textColor),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: primaryColor,
      ),
    );
  }
}
