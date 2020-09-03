import 'package:flutter/material.dart';

class SecondaryLightButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;

  const SecondaryLightButton({
    Key key,
    @required this.onPressed,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = Colors.white;
    var background = Theme.of(context).colorScheme.primary;
    if (Theme.of(context).brightness == Brightness.dark) {
      color = Theme.of(context).colorScheme.primary;
      background = Colors.transparent;
    }

    return FlatButton(
      padding: EdgeInsets.all(13),
      onPressed: onPressed,
      child: child,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: color, width: 0.5),
      ),
      color: background,
      textColor: color,
    );
  }
}
