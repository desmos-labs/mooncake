import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents a rounded button which has a gradient background that goes
/// from blue to violet.
class PrimaryRoundedButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final bool enabled;

  const PrimaryRoundedButton(
      {Key key,
      @required this.onPressed,
      @required this.text,
      this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradientButton(
      isEnabled: enabled,
      increaseWidthBy: double.infinity,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
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
