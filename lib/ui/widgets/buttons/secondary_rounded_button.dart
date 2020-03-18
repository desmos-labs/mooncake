import 'package:flutter/material.dart';
import 'package:mooncake/ui/theme/colors.dart';
import 'package:mooncake/ui/ui.dart';

class SecondaryRoundedButton extends StatelessWidget {
  final Function onPressed;
  final String text;

  const SecondaryRoundedButton({
    Key key,
    @required this.onPressed,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      color: Colors.transparent,
      textColor: Theme.of(context).accentColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: Theme.of(context).accentColor, width: 1),
      ),
      child: Text(text),
    );
  }
}
