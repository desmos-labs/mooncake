import 'package:flutter/material.dart';

/// Contains the decorations of the applications
class ThemeDecorations {
  static BoxDecoration get pattern => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF6C52C3), Color(0xFF904FFF)],
        ),
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            Colors.white.withOpacity(0.3),
            BlendMode.dstIn,
          ),
          image: AssetImage("assets/images/pattern.png"),
          repeat: ImageRepeat.repeat,
        ),
      );
}
