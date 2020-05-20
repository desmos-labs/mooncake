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
  final AccountImage profileImage;

  const AccountProfileImageViewer({
    Key key,
    this.radius = 40,
    this.border = 8,
    @required this.profileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImageProvider coverImage;
    final coverImageValue = profileImage;
    if (coverImageValue is LocalUserImage) {
      coverImage = FileImage(coverImageValue.image);
    } else if (coverImageValue is NetworkUserImage) {
      coverImage = NetworkImage(coverImageValue.url);
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
