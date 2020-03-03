import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents a primary button with a light background
/// and a rounded rectangle border.
class PrimaryLightRoundedButton extends StatelessWidget {
  final Function() onPressed;
  final Widget child;

  const PrimaryLightRoundedButton({
    Key key,
    @required this.onPressed,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: child,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      color: ThemeColors.primaryLightButtonBackgroundColor,
      textColor: ThemeColors.primaryLightButtonTextColor,
    );
  }
}
