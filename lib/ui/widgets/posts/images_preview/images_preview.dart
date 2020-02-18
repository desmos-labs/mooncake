import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';

import 'image_preview_item.dart';

/// Represents the list of images previews associated with a post.
class PostImagesPreview extends StatelessWidget {
  final bool allowsRemoval;
  final List<PostMedia> images;

  final OnMediaTap onTap;

  const PostImagesPreview({
    Key key,
    this.allowsRemoval = false,
    this.images,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width / 6.5;
    return SizedBox(
      height: size,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (BuildContext context, int index) {
          return ImagePreviewItem(
            onTap: onTap,
            size: size,
            media: images[index],
            allowEdits: allowsRemoval,
          );
        },
        separatorBuilder: (context, _) => SizedBox(width: 8),
      ),
    );
  }
}
