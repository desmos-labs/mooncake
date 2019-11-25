import 'package:desmosdemo/models/models.dart';
import 'package:desmosdemo/theme/theme.dart';
import 'package:flutter/material.dart';

/// Represents an image (given its [url]) as a circular image.
class PostAvatar extends StatelessWidget {
  final User user;

  PostAvatar({@required this.user, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      margin: EdgeInsets.only(right: 16.0),
      width: mediaQuery.size.width / 8,
      height: mediaQuery.size.width / 8,
      decoration: BoxDecoration(
        color: PostsTheme.theme.accentColor,
        borderRadius: BorderRadius.circular(mediaQuery.size.width / 16),
        image: user.hasAvatar
            ? DecorationImage(image: NetworkImage(user.avatarUrl))
            : null,
      ),
    );
  }
}
