import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';

/// Allows to properly show the given [coverImage].
class AccountCoverImageViewer extends StatelessWidget {
  final double height;
  final AccountImage coverImage;

  const AccountCoverImageViewer({
    Key key,
    this.height = 160,
    @required this.coverImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final coverImage = this.coverImage;
    if (coverImage is LocalUserImage) {
      return Image.file(
        coverImage.image,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    } else if (coverImage is NetworkUserImage) {
      return Image.network(
        coverImage.url,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    }

    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.25),
      width: width,
      height: height,
    );
  }
}
