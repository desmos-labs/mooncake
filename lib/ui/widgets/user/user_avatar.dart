import 'package:flutter/material.dart';

/// Represents an image (given its [url]) as a circular image.
class UserAvatar extends StatelessWidget {
  /// Bech32 address of the user
  final String user;

  /// Size of the icon
  double iconSize;

  UserAvatar({
    @required this.user,
    this.iconSize = 0,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    if (iconSize == 0) {
      iconSize = mediaQuery.size.width / 16;
    }

    return Container(
      width: iconSize * 2,
      height: iconSize * 2,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(iconSize),
      ),
    );
  }
}
