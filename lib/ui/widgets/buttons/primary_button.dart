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
  final bool expanded;

  const PrimaryButton({
    Key key,
    @required this.onPressed,
    @required this.child,
    this.borderRadius = 4.0,
    this.enabled = true,
    this.expanded = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Theme.of(context).brightness == Brightness.light
            ? _gradientButton(context)
            : _flatButton(context)
      ],
    );
  }

  Widget _gradientButton(BuildContext context) {
    return GradientButton(
      disabledGradient: ThemeColors.primaryButtonBackgroundGradientDiabled,
      isEnabled: enabled,
      increaseWidthBy: expanded ? double.infinity : 0,
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
    return SizedBox(
      width: double.infinity,
      child: FlatButton(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        onPressed: enabled ? onPressed : null,
        color: Theme.of(context).colorScheme.primary,
        child: child,
        textColor: Colors.white,
        disabledColor: Color.fromRGBO(169, 144, 255, 0.6),
        disabledTextColor: Colors.white,
      ),
    );
  }
}
