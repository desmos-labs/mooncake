import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// Allows to properly represent the avatar of a user given its data.
class AccountAvatar extends StatelessWidget {
  final double size;
  final double border;
  final User user;
  final Color borderColor;

  const AccountAvatar({
    Key key,
    this.size = 48,
    this.border = 0,
    this.borderColor = Colors.white,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size + border,
      height: size + border,
      padding: EdgeInsets.all(border),
      decoration: BoxDecoration(
        color: borderColor,
        borderRadius: BorderRadius.circular(1000),
      ),
      child: user.hasAvatar ? _profilePic() : _favIcon(),
    );
  }

  Widget _favIcon() {
    return CustomPaint(
      painter: JazzIconPainter(seed: user.address),
    );
  }

  Widget _profilePic() {
    final fromNetwork = user.profilePicUri?.startsWith('http') == true;
    return fromNetwork
        ? CachedNetworkImage(
            imageUrl: user.profilePicUri,
            imageBuilder: (_, image) => CircleAvatar(
              radius: size / 2,
              backgroundImage: image,
            ),
          )
        : CircleAvatar(
            radius: size / 2,
            backgroundImage: FileImage(File(user.profilePicUri)),
          );
  }
}
