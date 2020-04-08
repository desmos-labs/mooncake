import 'package:flutter/material.dart';
import 'package:mooncake/ui/theme/colors.dart';
import 'package:mooncake/ui/ui.dart';

class SecondaryRoundedButton extends StatelessWidget {
  final Function onPressed;
  final Widget child;
  final BorderRadius borderRadius;
  final Color color;

  const SecondaryRoundedButton({
    Key key,
    @required this.onPressed,
    @required this.child,
    this.borderRadius,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = this.color ?? Theme.of(context).accentColor;
    return FlatButton(
      onPressed: onPressed,
      color: Colors.transparent,
      textColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: this.borderRadius ?? BorderRadius.circular(4),
        side: BorderSide(color: color, width: 1),
      ),
      child: child,
    );
  }
}
