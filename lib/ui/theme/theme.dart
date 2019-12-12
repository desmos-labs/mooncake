import 'package:flutter/material.dart';

/// Allows to easily retrieve the data of the application theme
class PostsTheme {
  static Color get primaryColor => Color(0xFFE6559C);
  static Color get accentColor => Color(0xFFD10E6E);

  static Color get textColor => Colors.white;
  static Color get textColorLight => Colors.grey[500];

  static EdgeInsets get postItemPadding => EdgeInsets.all(16);

  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      accentColor: accentColor,

      // Define the default font family.
      fontFamily: 'Roboto',
      textTheme: TextTheme(
        body1: TextStyle(color: textColor),
      ),
      buttonTheme: ButtonThemeData(
          buttonColor: accentColor, textTheme: ButtonTextTheme.normal),
    );
  }
}
