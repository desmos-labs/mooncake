import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class LightboxScreen extends StatelessWidget {
  final List<PostMedia> photos;
  final int selectedIndex;

  const LightboxScreen({
    this.photos,
    this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    print("===photos====");
    print(photos);
    print("===photos====");
    print('===selected index===');
    print(selectedIndex);
    print('===selected index===');
    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: CachedNetworkImageProvider(photos[index].uri),
          initialScale: PhotoViewComputedScale.contained * 0.8,
        );
      },
      itemCount: photos.length,
      loadingBuilder: (context, event) => Center(
        child: Container(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / event.expectedTotalBytes,
          ),
        ),
      ),
      // backgroundDecoration: widget.backgroundDecoration,
      // pageController: widget.pageController,
      // onPageChanged: onPageChanged,
    );
    // return Container(
    //     child: PhotoView(
    //   imageProvider: CachedNetworkImageProvider(
    //       'https://ipfs.desmos.network/ipfs/QmWixmMGom6YiJBMXn3fAtpnqXhY2ivymsHaLRkqaDmFFS'),
    // ));
  }
}
