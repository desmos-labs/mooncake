import 'package:flutter/material.dart';

/// Allows to easily retrieve the data of the application theme
class PostsTheme {
  static Color get primaryColor => Color(0xFF946FAE);
  static Color get accentColor => Color(0xFFC77AAC);

  static Color get textColor => Colors.grey[800];
  static Color get textColorLight => Colors.grey[500];

  static EdgeInsets get postItemPadding => EdgeInsets.all(16);

  static ThemeData get theme {
    return ThemeData(
      iconTheme: IconThemeData(
        color: accentColor,
      ),
      brightness: Brightness.light,
      primaryColor: primaryColor,
      accentColor: accentColor,
      scaffoldBackgroundColor: Colors.grey[200],

      // Define the default font family.
      fontFamily: 'Roboto',
      textTheme: Typography.englishLike2018.copyWith(
        body1: TextStyle(color: textColor),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: accentColor,
        textTheme: ButtonTextTheme.normal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        )
      ),
    );
  }
}
