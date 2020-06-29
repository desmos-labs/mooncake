import 'package:flutter/material.dart';

class SecondaryLightRoundedButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;

  const SecondaryLightRoundedButton({
    Key key,
    @required this.onPressed,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Colors.white;
    if (Theme.of(context).brightness == Brightness.dark) {
      color = Theme.of(context).colorScheme.primary;
    }

    return FlatButton(
      padding: EdgeInsets.all(13),
      onPressed: onPressed,
      child: child,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: color, width: 0.5),
      ),
      color: Colors.transparent,
      textColor: color,
    );
  }
}
