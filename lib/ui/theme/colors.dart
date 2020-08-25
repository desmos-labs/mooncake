import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ThemeColors {
  static const LinearGradient primaryButtonBackgroundGradient = LinearGradient(
    colors: [Color(0xFF5277FF), Color(0xFF904FFF)],
    begin: Alignment(-0.44, -0.89),
    end: Alignment(1, 1),
  );

  static const LinearGradient primaryButtonBackgroundGradientDiabled =
      LinearGradient(
    colors: [
      Color.fromRGBO(82, 119, 255, 0.6),
      Color.fromRGBO(144, 79, 255, 0.6)
    ],
    begin: Alignment(-0.44, -0.89),
    end: Alignment(1, 1),
  );

  static LinearGradient primaryButtonFlat(BuildContext context) =>
      LinearGradient(
        colors: [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.primary,
        ],
        begin: Alignment(-0.44, -0.89),
        end: Alignment(1, 1),
      );

  static const LinearGradient primaryButtonFlatDisabled = LinearGradient(
    colors: [
      Color.fromRGBO(169, 144, 255, 0.6),
      Color.fromRGBO(169, 144, 255, 0.6),
    ],
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

  // --- Loading bars ---
  static Color get loadingBarBackgroundColor => Color(0xFFECECEC);

  // --- Others ---
  static Color reactionBackground(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      return Color(0xFF7F7F7);
    }
    return Color(0xFF7F7F7);
  }
}
