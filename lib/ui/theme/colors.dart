import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ThemeColors {
  // --- Splash screen ---
  static const Color splashScreenBackgroundColor = Color(0xFF8164E5);

  // --- Login ---
  static const Color loginBackgroundColor = Color(0xFF6C52C3);
  static const Color loginPopupTitleColor = Color(0xFF6D4DDB);

  // --- Buttons ---
  static const Color primaryLightButtonTextColor = Color(0xFF6C52C3);
  static const Color primaryLightButtonBackgroundColor = Colors.white;

  static const Color secondaryLightButtonTextColor = Colors.white;
  static const Color secondaryLightButtonBackgroundColor = Colors.transparent;

  static const Color primaryButtonTextColor = Colors.white;
  static const LinearGradient primaryButtonBackgroundGradient = LinearGradient(
    colors: [Color(0xFF5277FF), Color(0xFF904FFF)],
    begin: Alignment(-0.44, -0.89),
    end: Alignment(1, 1),
  );

  static const Color secondaryButtonTextColor = Color(0xFF8164E5);
  static const Color secondaryButtonBackgroundColor = Colors.transparent;
}
