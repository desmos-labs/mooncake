import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ThemeColors {
  static Color accentColor(Brightness brightness) {
    switch (brightness) {
      case Brightness.dark:
        return Color(0xFFc2b1ff);
      default:
        return Color(0xFF8164E5);
    }
  }

  static const LinearGradient primaryButtonBackgroundGradient = LinearGradient(
    colors: [Color(0xFF5277FF), Color(0xFF904FFF)],
    begin: Alignment(-0.44, -0.89),
    end: Alignment(1, 1),
  );

  static LinearGradient get gradient => LinearGradient(
        colors: [Color(0xFF904FFF), Color(0xFF5277FF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  // --- Texts ---
  static Color get textColorLight => Colors.grey[700];
  static Color get textColorVeryLight => Colors.grey[500];

  // --- Loading bars ---
  static Color get loadingBarBackgroundColor => Color(0xFFECECEC);
}
