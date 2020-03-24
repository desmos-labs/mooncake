import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';

/// Allows to properly represent the avatar of a user given its data.
class UserAvatar extends StatelessWidget {
  final double size;
  final double border;
  final User user;
  final Color borderColor;

  const UserAvatar({
    Key key,
    this.size = 48,
    this.border = 0,
    this.borderColor = Colors.white,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final radius = size / 2;
    return CircleAvatar(
      radius: border == 0 ? radius : radius + border,
      backgroundColor: borderColor,
      child: CachedNetworkImage(
        imageUrl: user.hasAvatar
            ? user.avatarUrl
            : "http://identicon-1132.appspot.com/${user.address}",
        imageBuilder: (context, image) => CircleAvatar(
          radius: radius,
          backgroundImage: image,
        ),
      ),
    );
  }
}
