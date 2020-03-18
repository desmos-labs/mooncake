import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:url_launcher/url_launcher.dart';

/// Represents a single image items that should be displayed as part
/// of the post content.
class PostContentImage extends StatelessWidget {
  final PostMedia media;

  const PostContentImage({Key key, this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: _openImage,
        child: Image(
          width: double.infinity,
          fit: BoxFit.cover,
          image: media.isLocal
              ? FileImage(File(media.url))
              : NetworkImage(media.url),
        ),
      ),
    );
  }

  void _openImage() async {
    if (await canLaunch(media.url)) {
      await launch(media.url);
    }
  }
}
