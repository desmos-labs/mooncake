import 'package:flutter/widgets.dart';

/// Extends [IconData] to properly show a Mooncake icon.
class IconDataMooncake extends IconData {
  const IconDataMooncake(int codePoint)
      : super(
          codePoint,
          fontFamily: 'Mooncake',
        );
}
