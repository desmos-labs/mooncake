import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class LightboxScreen extends StatefulWidget {
  final List<PostMedia> photos;
  final int selectedIndex;
  final PageController pageController;

  LightboxScreen({
    this.photos,
    this.selectedIndex,
  }) : pageController = PageController(
          initialPage: selectedIndex,
        );

  @override
  _LightboxScreenState createState() => _LightboxScreenState();
}

class _LightboxScreenState extends State<LightboxScreen> {
  int currentIndex;

  @override
  void initState() {
    currentIndex = widget.selectedIndex;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: CachedNetworkImageProvider(widget.photos[index].uri),
          initialScale: PhotoViewComputedScale.contained * 0.8,
        );
      },
      itemCount: widget.photos.length,
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
      backgroundDecoration: BoxDecoration(
        color: Colors.pink.withOpacity(0.2),
      ),
      pageController: widget.pageController,
      onPageChanged: onPageChanged,
      scrollDirection: Axis.horizontal,
    );
    // return Container(
    //     child: PhotoView(
    //   imageProvider: CachedNetworkImageProvider(
    //       'https://ipfs.desmos.network/ipfs/QmWixmMGom6YiJBMXn3fAtpnqXhY2ivymsHaLRkqaDmFFS'),
    // ));
  }
}
