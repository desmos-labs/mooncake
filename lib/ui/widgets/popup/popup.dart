import 'package:flutter/material.dart';

/// Represents a generic white background popup.
class GenericPopup extends StatelessWidget {
  final Color backgroundColor;
  final Widget content;
  final Function onTap;

  const GenericPopup({
    Key key,
    @required this.content,
    this.backgroundColor = Colors.transparent,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: backgroundColor,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
    );
  }
}
