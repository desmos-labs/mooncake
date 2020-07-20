import 'package:flutter/material.dart';

class SecondaryLightInvertRoundedButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;
  final double width;

  const SecondaryLightInvertRoundedButton({
    Key key,
    @required this.onPressed,
    @required this.child,
    this.width = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.primary;

    return SizedBox(
      width: width,
      child: FlatButton(
        padding: EdgeInsets.all(13),
        onPressed: onPressed,
        child: child,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(color: color, width: 0.5),
        ),
        color: Colors.transparent,
        textColor: color,
      ),
    );
  }
}
