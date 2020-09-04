import 'dart:io';

import 'package:flutter/material.dart';

/// Allows to properly show the given [coverImage].
class AccountCoverImageViewer extends StatelessWidget {
  final double height;
  final String coverImage;

  const AccountCoverImageViewer({
    Key key,
    this.height = 160,
    @required this.coverImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final coverImage = this.coverImage;
    if (coverImage?.startsWith('http') == false) {
      return Image.file(
        File(coverImage),
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    } else if (coverImage?.startsWith('http') == true) {
      return Image.network(
        coverImage,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    }

    return Container(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.25),
      width: width,
      height: height,
    );
  }
}
