import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents a rounded button which has a gradient background that goes
/// from blue to violet.
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
    return GradientButton(
      callback: onPressed,
      gradient: ThemeColors.primaryButtonBackgroundGradient,
      shadowColor: Colors.transparent,
      elevation: 0,
      child: Text(
        text,
        style: TextThemes.primaryButtonTextStyle(context),
      ),
    );
  }
}
