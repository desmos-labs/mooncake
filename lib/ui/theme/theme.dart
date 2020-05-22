import 'package:flutter/material.dart';
import 'package:mooncake/ui/theme/colors.dart';

export 'colors.dart';
export 'spaces.dart';
export 'decorations.dart';

/// Allows to easily retrieve the data of the application theme
class PostsTheme {
  static const double defaultPadding = 10.0;

  static EdgeInsets get postItemPadding => EdgeInsets.all(16);

  static ThemeData fromColorScheme(ColorScheme scheme) {
    final iconTheme = IconThemeData(color: scheme.primary);
    return ThemeData.from(colorScheme: scheme).copyWith(
      appBarTheme: AppBarTheme(
        elevation: 0,
        color: Colors.transparent,
        textTheme: TextTheme(
          headline6: Typography.englishLike2018.headline6.copyWith(
            color: scheme.primary,
          ),
        ),
        iconTheme: iconTheme,
        actionsIconTheme: iconTheme,
      ),
      iconTheme: iconTheme,
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        disabledBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
      ),
    );
  }

  static ThemeData get _lightTheme {
    return fromColorScheme(ColorScheme(
      primary: Color(0xFF6D4DDB),
      primaryVariant: Color(0xFF904FFF),
      secondary: Color(0xFF007AFF),
      secondaryVariant: Color(0xFF5277FF),
      surface: Color(0xFFFFFFFF),
      background: Color(0xFFF4F4FC),
      error: Color(0xFFE84444),
      onPrimary: Color(0xFF000000),
      onSecondary: Color(0xFF000000),
      onSurface: Color(0xFF646464),
      onBackground: Color(0xFF000000),
      onError: Color(0xFFACACAC),
      brightness: Brightness.light,
    ));
  }

  static ThemeData get _darkTheme {
    return fromColorScheme(ColorScheme(
      primary: Color(0xFFA990FF),
      primaryVariant: Color(0xFF6625EE),
      secondary: Color(0xFF439DFF),
      secondaryVariant: Color(0xFF5277FF),
      surface: Color(0xFF2C2A50),
      background: Color(0xFF1F1C45),
      error: Color(0xFFE84444),
      onPrimary: Color(0x5aFFFFFF),
      onSecondary: Color(0x5aFFFFFF),
      onSurface: Color(0x3cFFFFFF),
      onBackground: Color(0x5aFFFFFF),
      onError: Color(0x3cFFFFFF),
      brightness: Brightness.dark,
    ));
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
