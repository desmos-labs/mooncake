import 'package:flutter/material.dart';

/// Represents a generic white background popup.
class GenericPopup extends StatelessWidget {
  final Color backgroundColor;
  final Widget content;
  final EdgeInsets padding;
  final void Function() onTap;
  final double width;

  const GenericPopup({
    Key key,
    @required this.content,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
    this.onTap,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: backgroundColor ??
            Theme.of(context).colorScheme.onSurface.withOpacity(0.50),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Material(
            elevation: 6,
            color: Colors.transparent,
            child: Container(
              padding: padding,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).cardColor,
              ),
              child: Wrap(
                children: [
                  content,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
