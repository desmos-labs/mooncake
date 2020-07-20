import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'fonts.dart';

/// Allows to easily retrieve the data of the application theme
class PostsTheme {
  static ThemeData from({
    @required ColorScheme colorScheme,
    @required IconThemeData iconTheme,
    @required TextTheme textTheme,
    @required Brightness brightness,
  }) {
    return ThemeData.from(colorScheme: colorScheme).copyWith(
      appBarTheme: AppBarTheme(
        brightness: brightness,
        elevation: 0,
        color: Colors.transparent,
        textTheme: Typography.englishLike2018.copyWith(
          headline6: Typography.englishLike2018.headline6.copyWith(
            color: colorScheme.primary,
          ),
        ),
        iconTheme: IconThemeData(color: colorScheme.primary),
      ),
      iconTheme: iconTheme,
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        focusColor: colorScheme.primary,
      ),
      buttonColor: colorScheme.primary,
      textTheme: Typography.englishLike2018
          .copyWith(
            bodyText2: Typography.englishLike2018.bodyText2.copyWith(
              fontSize: 16,
            ),
          )
          .merge(textTheme),
    );
  }

  static ThemeData get lightTheme {
    final scheme = ColorScheme.light(
      primary: Color(0xFF6D4DDB),
      primaryVariant: Color(0xFF904FFF),
      secondary: Color(0xFF147AFC),
      secondaryVariant: Color(0xFF5277FF),
      surface: Color(0xFFFFFFFF),
      background: Color(0xFFF4F4FC),
      error: Color(0xFFE84444),
      onPrimary: Color(0xFF000000),
      onSecondary: Color(0xFF646464),
      onError: Color(0xFFACACAC),
      onSurface: Color(0xFF000000),
      onBackground: Color(0xFF646464),
    );
    final iconTheme = IconThemeData(color: Color(0xFF646464));
    return from(
      colorScheme: scheme,
      iconTheme: iconTheme,
      brightness: Brightness.light,
      textTheme: defaultTargetPlatform == TargetPlatform.iOS
          ? Typography.blackCupertino.merge(ThemeFonts.iOSTextTheme)
          : Typography.blackMountainView,
    );
  }

  static ThemeData get darkTheme {
    final scheme = ColorScheme.dark(
      primary: Color(0xFFA990FF),
      primaryVariant: Color(0xFF6625EE),
      secondary: Color(0xFF439DFF),
      secondaryVariant: Color(0xFF5277FF),
      error: Color(0xFFE84444),
      surface: Color(0xFF1A1A1F),
      background: Color(0xFF020207),
      onPrimary: Color(0xFFFFFFFF).withOpacity(0.85),
      onSecondary: Color(0xFFFFFFFF).withOpacity(0.60),
      onError: Color(0xFFFFFFFF).withOpacity(0.60),
      onSurface: Color(0xFF32323E),
      onBackground: Color(0xFFFFFFFF).withOpacity(0.6),
    );
    final iconTheme = IconThemeData(color: Color(0xFFFFFFFF).withOpacity(0.6));
    return from(
      colorScheme: scheme,
      iconTheme: iconTheme,
      brightness: Brightness.dark,
      textTheme: defaultTargetPlatform == TargetPlatform.iOS
          ? Typography.whiteCupertino.merge(ThemeFonts.iOSTextTheme)
          : Typography.whiteMountainView,
    );
  }
}
