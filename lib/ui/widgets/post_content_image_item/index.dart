import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents a single image items that should be displayed as part
/// of the post content.
class PostContentImage extends StatelessWidget {
  final PostMedia media;
  final Function onTap;
  final int index;

  const PostContentImage({
    Key key,
    this.media,
    this.onTap,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () => onTap(index),
        child: media.isLocal ? _localImage(media.uri) : _remoteImage(media.uri),
      ),
    );
  }

  Widget _localImage(String url) {
    return Image(
      width: double.infinity,
      fit: BoxFit.cover,
      image: FileImage(File(url)),
    );
  }

  Widget _remoteImage(String url) {
    return CachedNetworkImage(
      width: double.infinity,
      fit: BoxFit.cover,
      imageUrl: media.uri,
      placeholder: (context, _) => LoadingIndicator(),
    );
  }
}
