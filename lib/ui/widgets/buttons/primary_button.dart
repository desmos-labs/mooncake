import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents a rounded button which has a gradient background that goes
/// from blue to violet.
class PrimaryButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;
  final bool enabled;
  final double borderRadius;

  const PrimaryButton({
    Key key,
    @required this.onPressed,
    @required this.child,
    this.borderRadius = 4.0,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? _gradientButton(context)
        : _flatButton(context);
  }

  Widget _gradientButton(BuildContext context) {
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
      textStyle: Theme.of(context).textTheme.bodyText2.copyWith(
            color: Colors.white,
          ),
      child: child,
    );
  }

  Widget _flatButton(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      onPressed: enabled ? onPressed : null,
      color: Theme.of(context).colorScheme.primary,
      child: child,
      textColor: Colors.white,
    );
  }
}
