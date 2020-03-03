import 'package:flutter/material.dart';

export 'colors.dart';
export 'text_themes.dart';

/// Allows to easily retrieve the data of the application theme
class PostsTheme {
  static const double defaultPadding = 10.0;

  static Color get borderColor => Colors.grey[500];
  static LinearGradient get gradient => LinearGradient(
        colors: [Color(0xFF904FFF), Color(0xFF5277FF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  static Color get primaryColor => Colors.white;
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
      scaffoldBackgroundColor: Colors.white,

      // Define the default font family.
      fontFamily: 'Montserrat',
      textTheme: Typography.englishLike2018.copyWith(
        bodyText2: TextStyle(color: textColor, fontWeight: FontWeight.w400),
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
