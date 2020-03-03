import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

class PrimaryRoundedButton extends StatelessWidget {
  final Function onPressed;
  final String text;

  const PrimaryRoundedButton({
    Key key,
    @required this.onPressed,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      padding: EdgeInsets.all(0),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: ThemeColors.primaryButtonBackgroundGradient,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: EdgeInsets.all(10),
        child: Text(
          text,
          style: TextThemes.primaryButtonTextStyle(context),
        ),
      ),
    );
  }
}
