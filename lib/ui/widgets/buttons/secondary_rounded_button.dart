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
      color: ThemeColors.secondaryButtonBackgroundColor,
      textColor: ThemeColors.secondaryButtonTextColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: ThemeColors.secondaryButtonTextColor, width: 1),
      ),
      child: Text(
        text,
        style: TextThemes.secondaryButtonTextStyle(context),
      ),
    );
  }
}
