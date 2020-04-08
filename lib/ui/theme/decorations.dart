import 'package:flutter/material.dart';
import 'package:mooncake/ui/theme/colors.dart';

/// Contains the decorations of the applications
class ThemeDecorations {
  static List<Color> _patternColors(BuildContext context) {
    switch (Theme.of(context).brightness) {
      case Brightness.light:
        return [Color(0xFF6C52C3), Color(0xFF904FFF)];
      case Brightness.dark:
        return [Color(0xFF1B1659), Color(0xFF11101D)];
    }
  }

  static BoxDecoration pattern(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: _patternColors(context),
      ),
      image: DecorationImage(
        colorFilter: ColorFilter.mode(
          Colors.white.withOpacity(
                Theme.of(context).brightness == Brightness.light ? 0.25 : 0.10,
              ),
          BlendMode.dstIn,
        ),
        image: AssetImage("assets/images/pattern.png"),
        repeat: ImageRepeat.repeat,
      ),
    );
  }
}
