import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class LightboxScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoView(
      imageProvider: CachedNetworkImageProvider(
          'https://ipfs.desmos.network/ipfs/QmWixmMGom6YiJBMXn3fAtpnqXhY2ivymsHaLRkqaDmFFS'),
    ));
  }
}
