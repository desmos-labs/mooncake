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

  PrimaryButton({
    Key key,
    @required this.onPressed,
    @required this.child,
    this.borderRadius = 4.0,
    this.enabled = true,
    this.expanded = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLight = Theme.of(context).brightness == Brightness.light;
    LinearGradient disabledGradient = isLight
        ? ThemeColors.primaryButtonBackgroundGradientDiabled
        : ThemeColors.primaryButtonFlatDisabled;
    LinearGradient gradient = isLight
        ? ThemeColors.primaryButtonBackgroundGradient
        : ThemeColors.primaryButtonFlat(context);
    return Wrap(
      children: [
        GradientButton(
          disabledGradient: disabledGradient,
          isEnabled: enabled,
          increaseWidthBy: expanded ? double.infinity : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          callback: onPressed,
          gradient: gradient,
          shadowColor: Colors.transparent,
          elevation: 0,
          textStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                color: Colors.white,
              ),
          child: child,
        ),
      ],
    );
  }
}
