import 'package:flutter/material.dart';

/// Contains the decorations of the applications
class ThemeDecorations {
  static Map _generateModeResources(BuildContext context) {
    switch (Theme.of(context).brightness) {
      case Brightness.light:
        return {
          'colors': [Color(0xFF575FFF), Color(0xFF8655FF)],
          'pattern': AssetImage('assets/images/pattern.png'),
          'opacity': 0.35,
          'alignment': Alignment(0.5, 0.5),
        };
      default:
        return {
          'colors': [Color(0xFF020207), Color(0xFF0D0B21)],
          'pattern': AssetImage('assets/images/pattern_dark.png'),
          'opacity': 0.35,
          'alignment': Alignment.bottomCenter,
        };
    }
  }

  static BoxDecoration pattern(BuildContext context) {
    final resources = _generateModeResources(context);
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: resources['alignment'] as Alignment,
        colors: resources['colors'] as List<Color>,
      ),
      image: DecorationImage(
        colorFilter: ColorFilter.mode(
          Colors.white.withOpacity(
            resources['opacity'] as double,
          ),
          BlendMode.dstIn,
        ),
        image: resources['pattern'] as AssetImage,
        repeat: ImageRepeat.repeat,
      ),
    );
  }
}
