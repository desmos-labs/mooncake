import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';

/// Allows to properly represent the avatar of a user given its data.
class UserAvatar extends StatelessWidget {
  final double size;
  final User user;

  const UserAvatar({
    Key key,
    this.size,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size,
      backgroundImage: NetworkImage(
        user.hasAvatar
            ? user.avatarUrl
            : "http://identicon-1132.appspot.com/${user.accountData.address}",
      ),
    );
  }
}
