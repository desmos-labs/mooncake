import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Represents a primary button with a light background
/// and a rounded rectangle border.
class PrimaryLightButton extends StatelessWidget {
  final Function() onPressed;
  final Widget child;
  final double borderRadius;

  const PrimaryLightButton({
    Key key,
    @required this.onPressed,
    @required this.child,
    this.borderRadius = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var backgroundColor = Colors.white;
    var textColor = Theme.of(context).colorScheme.primary;

    if (Theme.of(context).brightness == Brightness.dark) {
      backgroundColor = Theme.of(context).colorScheme.primary;
      textColor = Colors.white;
    }

    return FlatButton(
      padding: EdgeInsets.all(13),
      onPressed: onPressed,
      child: child,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      color: backgroundColor,
      textColor: textColor,
    );
  }
}
