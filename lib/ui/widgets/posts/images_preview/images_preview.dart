import 'dart:io';

import 'package:flutter/material.dart';
import 'image_preview_item.dart';

/// Represents the list of images previews associated with a post.
class PostImagesPreview extends StatelessWidget {
  final List<File> images;

  const PostImagesPreview({Key key, this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width / 6.5;
    return SizedBox(
      height: size,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (BuildContext context, int index) {
          return ImagePreviewItem(size: size, image: images[index]);
        },
        separatorBuilder: (context, _) => SizedBox(width: 8),
      ),
    );
  }
}
