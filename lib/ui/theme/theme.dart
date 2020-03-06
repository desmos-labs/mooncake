import 'package:flutter/material.dart';
import 'package:mooncake/ui/theme/colors.dart';

export 'colors.dart';
export 'text_themes.dart';
export 'spaces.dart';

/// Allows to easily retrieve the data of the application theme
class PostsTheme {
  static const double defaultPadding = 10.0;

  static Color get borderColor => Colors.grey[500];
  static LinearGradient get gradient => LinearGradient(
        colors: [Color(0xFF904FFF), Color(0xFF5277FF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  static EdgeInsets get postItemPadding => EdgeInsets.all(16);

  static ThemeData get theme {
    return ThemeData(
      iconTheme: IconThemeData(
        color: ThemeColors.accentColor,
      ),
      brightness: Brightness.light,
      primaryColor: ThemeColors.primaryColor,
      accentColor: ThemeColors.accentColor,
      primaryColorLight: Colors.white,
      scaffoldBackgroundColor: Colors.white,

      // Define the default font family.
      fontFamily: 'Montserrat',
      textTheme: Typography.englishLike2018.copyWith(
        bodyText2: TextStyle(color: ThemeColors.textColor),
      ),
      accentTextTheme: Typography.englishLike2018.copyWith(
        bodyText2: TextStyle(color: ThemeColors.textColorAccent),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: ThemeColors.accentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }
}
