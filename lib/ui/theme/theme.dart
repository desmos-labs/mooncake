import 'package:flutter/material.dart';
import 'package:mooncake/ui/theme/colors.dart';

export 'colors.dart';
export 'spaces.dart';
export 'decorations.dart';

/// Allows to easily retrieve the data of the application theme
class PostsTheme {
  static const double defaultPadding = 10.0;

  static EdgeInsets get postItemPadding => EdgeInsets.all(16);

  static ThemeData get _lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      appBarTheme: AppBarTheme(
        elevation: 0,
        color: Colors.transparent,
        textTheme: TextTheme(
          headline6: Typography.englishLike2018.headline6.copyWith(
            color: Color(0xFF8164E5),
          ),
        ),
        iconTheme: IconThemeData(
          color: Color(0xFF8164E5),
        ),
      ),
      iconTheme: IconThemeData(
        color: Color(0xFF6D4DDB),
      ),
      primaryColor: Colors.white,
      primaryColorLight: Colors.white,
      primaryColorDark: Color(0xFFF4F4FC),
      accentColor: Color(0xFF8164E5),
      errorColor: Color(0xFFE84444),
      scaffoldBackgroundColor: Color(0xFFF4F4FC),
      cardColor: Colors.white,
      accentTextTheme: Typography.englishLike2018.copyWith(
        headline5: Typography.englishLike2018.headline5.copyWith(
          color: Color(0xFF6D4DDB),
        ),
        headline6: Typography.englishLike2018.headline6.copyWith(
          color: Color(0xFF6D4DDB),
        ),
        bodyText2: Typography.englishLike2018.bodyText2.copyWith(
          color: Color(0xFF6D4DDB),
        ),
        caption: Typography.englishLike2018.caption.copyWith(
          color: Color(0xFF6D4DDB),
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Color(0xFF6D4DDB),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }

  static ThemeData get _darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.transparent,
          iconTheme: IconThemeData(
            color: Colors.white,
          )),
      iconTheme: IconThemeData(
        color: Color(0xFFA990FF),
      ),
      primaryColor: Color(0xFF1F1C45),
      primaryColorLight: Color(0xFFB7A2FF),
      primaryColorDark: Color(0xFF423F64),
      accentColor: Colors.white,
      errorColor: Color(0xFFE84444),
      scaffoldBackgroundColor: Color(0xFF1F1C45),
      cardColor: Color(0xFF2C2A50),
      accentTextTheme: Typography.englishLike2018.copyWith(
        headline5: Typography.englishLike2018.headline5.copyWith(
          color: Colors.white,
        ),
        headline6: Typography.englishLike2018.headline6.copyWith(
          color: Colors.white,
        ),
        bodyText2: Typography.englishLike2018.bodyText2.copyWith(
          color: Colors.white,
        ),
        caption: Typography.englishLike2018.caption.copyWith(
          color: Colors.white,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Color(0xFF6D4DDB),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }

  static ThemeData themeBuilder(Brightness brightness) {
    switch (brightness) {
      case Brightness.dark:
        return _darkTheme;
      default:
        return _lightTheme;
    }
  }
}
