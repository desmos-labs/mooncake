import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';

/// Allows to visualize the given [profileImage].
///
/// If [radius] and [border] are specified, the image will be of those
/// given, sizes.
class AccountProfileImageViewer extends StatelessWidget {
  final double radius;
  final double border;
  final String profileImage;

  const AccountProfileImageViewer({
    Key key,
    this.radius = 40,
    this.border = 8,
    @required this.profileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(profileImage);

    ImageProvider coverImage;
    if (profileImage?.startsWith("http") == true) {
      coverImage = NetworkImage(profileImage);
    } else if (profileImage?.startsWith("http") == false) {
      coverImage = FileImage(File(profileImage));
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).backgroundColor,
      child: CircleAvatar(
        radius: radius - border,
        backgroundColor: coverImage != null
            ? null
            : Theme.of(context).primaryColor.withOpacity(0.25),
        backgroundImage: coverImage,
      ),
    );
  }
}
