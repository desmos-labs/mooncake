import 'package:flutter/material.dart';

/// Allows to easily retrieve the data of the application theme
class PostsTheme {
  static const double defaultPadding = 10.0;

  static Color get primaryColor => Color(0xFF946FAE);
  static Color get accentColor => Color(0xFFA94E89);

  static Color get textColor => Colors.grey[800];
  static Color get textColorLight => Colors.grey[700];
  static Color get textColorVeryLight => Colors.grey[500];

  static EdgeInsets get postItemPadding => EdgeInsets.all(16);

  static BoxDecoration get pattern => const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/pattern.png"),
          repeat: ImageRepeat.repeat,
        ),
      );

  static ThemeData get theme {
    return ThemeData(
      iconTheme: IconThemeData(
        color: accentColor,
      ),
      brightness: Brightness.light,
      primaryColor: primaryColor,
      accentColor: accentColor,
      primaryColorLight: Colors.white,
      scaffoldBackgroundColor: Colors.grey[200],

      // Define the default font family.
      fontFamily: 'Roboto',
      textTheme: Typography.englishLike2018.copyWith(
        bodyText2: TextStyle(color: textColor, fontWeight: FontWeight.w500),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: accentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }
}
