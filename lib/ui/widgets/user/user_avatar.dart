import 'package:dwitter/ui/ui.dart';
import 'package:flutter/material.dart';

/// Represents an image (given its [url]) as a circular image.
class UserAvatar extends StatelessWidget {
  /// Bech32 address of the user
  final String user;

  UserAvatar({@required this.user, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      width: mediaQuery.size.width / 8,
      height: mediaQuery.size.width / 8,
      decoration: BoxDecoration(
        color: PostsTheme.theme.primaryColor,
        borderRadius: BorderRadius.circular(mediaQuery.size.width / 16),
// TODO: Implement this again
//        image: user.hasAvatar
//            ? DecorationImage(image: NetworkImage(user.avatarUrl))
//            : null,
      ),
    );
  }
}
