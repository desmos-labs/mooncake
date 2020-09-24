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
    return Stack(
      children: [
        PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: _buildItem,
          // builder: (BuildContext context, int index) {
          // return PhotoViewGalleryPageOptions(
          //   imageProvider: CachedNetworkImageProvider(widget.photos[index].uri),
          //   initialScale: PhotoViewComputedScale.contained * 0.5,
          // );
          // },
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
        ),
        Text("stack it upp"),
      ],
    );
    // return Container(
    //     child: PhotoView(
    //   imageProvider: CachedNetworkImageProvider(
    //       'https://ipfs.desmos.network/ipfs/QmWixmMGom6YiJBMXn3fAtpnqXhY2ivymsHaLRkqaDmFFS'),
    // ));
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final item = widget.photos[index];
    return PhotoViewGalleryPageOptions.customChild(
      child: CachedNetworkImage(
        width: double.infinity,
        fit: BoxFit.cover,
        imageUrl: item.uri,
        placeholder: (context, _) => LoadingIndicator(),
      ),
      childSize: const Size(300, 300),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
    );
    // return item.isSvg
    //     ? PhotoViewGalleryPageOptions.customChild(
    //         child: Container(
    //           width: 300,
    //           height: 300,
    //           child: SvgPicture.asset(
    //             item.resource,
    //             height: 200.0,
    //           ),
    //         ),
    //         childSize: const Size(300, 300),
    //         initialScale: PhotoViewComputedScale.contained,
    //         minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
    //         maxScale: PhotoViewComputedScale.covered * 4.1,
    //         heroAttributes: PhotoViewHeroAttributes(tag: item.id),
    //       )
    //     : PhotoViewGalleryPageOptions(
    //         imageProvider: AssetImage(item.resource),
    //         initialScale: PhotoViewComputedScale.contained,
    //         minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
    //         maxScale: PhotoViewComputedScale.covered * 4.1,
    //         heroAttributes: PhotoViewHeroAttributes(tag: item.id),
    //       );
  }
}
