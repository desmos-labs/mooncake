import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

class SecondaryLightRoundedButton extends StatelessWidget {
  final Function onPressed;
  final Widget child;

  const SecondaryLightRoundedButton({
    Key key,
    @required this.onPressed,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: child,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: Colors.white, width: 0.5),
      ),
      color: ThemeColors.secondaryLightButtonBackgroundColor,
      textColor: ThemeColors.secondaryLightButtonTextColor,
    );
  }
}
