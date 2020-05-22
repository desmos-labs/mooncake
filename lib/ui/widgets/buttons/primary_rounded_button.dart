import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents a rounded button which has a gradient background that goes
/// from blue to violet.
class PrimaryRoundedButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final bool enabled;
  final double borderRadius;

  const PrimaryRoundedButton(
      {Key key,
      @required this.onPressed,
      @required this.text,
      this.borderRadius = 4.0,
      this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradientButton(
      isEnabled: enabled,
      increaseWidthBy: double.infinity,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      callback: onPressed,
      gradient: ThemeColors.primaryButtonBackgroundGradient,
      shadowColor: Colors.transparent,
      elevation: 0,
      child: Text(text,
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: Colors.white,
              )),
    );
  }
}
