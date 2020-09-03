import 'dart:convert';
import 'dart:math';

import 'package:flutter/widgets.dart';

/// This painter allows to paint a Jazzicon.
/// The original JaaScript implementation can be found here:
/// https://github.com/danfinlay/jazzicon. This is just a porting with some
/// minor changes to make it look good on mobile apps.
@immutable
class JazzIconPainter extends CustomPainter {
  static const SHAPE_COUNT = 4;

  static const COLORS = [
    '#01888C', // teal
    '#FC7500', // bright orange
    '#034F5D', // dark teal
    '#F73F01', // orangered
    '#FC1960', // magenta
    '#C7144C', // raspberry
    '#F3C100', // goldenrod
    '#1598F2', // lightning blue
    '#2465E1', // sail blue
    '#F19E02', // gold
  ];

  final String seed;

  JazzIconPainter({@required String seed}) : seed = seed ?? 'icon';

  @override
  bool shouldRepaint(JazzIconPainter oldDelegate) {
    return seed != oldDelegate.seed;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final generator = Random(utf8.encode(seed).reduce((a, b) => a + b));
    final colors = hueShift(COLORS, generator);

    // Background color
    canvas.clipRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(size.width / 2),
    ));
    canvas.drawPaint(Paint()..color = genColor(generator, colors));

    // Clip to be a circle
    for (var i = 0; i < SHAPE_COUNT - 1; i++) {
      genShape(generator, colors, size.width, i, SHAPE_COUNT - 1, canvas);
    }
  }

  void genShape(
    Random generator,
    List<Color> remainingColors,
    double diameter,
    int i,
    int total,
    Canvas svg,
  ) {
    final shape = Rect.fromLTWH(0, 0, diameter, diameter);

    final firstRotation = generator.nextDouble();
    final angle = pi * firstRotation;
    final velocity =
        diameter / total * generator.nextDouble() + (i * diameter / total);

    final tx = cos(angle) * velocity % diameter;
    final ty = sin(angle) * velocity % diameter;

    final translate = shape.translate(tx, ty);

    // Third random is a shape rotation on top of all of that.
    final secondRotation = generator.nextDouble();
    final rot = ((firstRotation * 360) + secondRotation * 180) * pi / 180;

    svg.translate(diameter / 2, diameter / 2);
    svg.rotate(rot);
    svg.translate(-diameter / 2, -diameter / 2);

    final fill = genColor(generator, remainingColors);
    svg.drawRect(translate, Paint()..color = fill);
  }

  final wobble = 30;
  List<Color> hueShift(List<String> colors, Random generator) {
    return colors.map((hex) {
      return Color(int.parse(hex.substring(1, 7), radix: 16) + 0xFF000000);
    }).toList();
  }

  Color genColor(Random generator, List<Color> colors) {
    var rand = generator.nextInt(colors.length);
    return colors[rand];
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;

    return other is JazzIconPainter && other.seed == seed;
  }

  @override
  int get hashCode => hashValues(seed, 0);
}
