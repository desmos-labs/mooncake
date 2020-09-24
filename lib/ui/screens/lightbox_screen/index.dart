import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

/// Takes an array of PostMedia and will
/// Generate a lightbox at the top of the stack.
/// Once closed, the screen will be popped
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
    return Scaffold(
      body: Container(
        color: Colors.grey[900],
        child: SafeArea(
          child: Stack(
            children: [
              PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: _buildItem,
                itemCount: widget.photos.length,
                loadingBuilder: (context, event) => Center(
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      value: event == null
                          ? 0
                          : event.cumulativeBytesLoaded /
                              event.expectedTotalBytes,
                    ),
                  ),
                ),
                backgroundDecoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                pageController: widget.pageController,
                onPageChanged: onPageChanged,
                scrollDirection: Axis.horizontal,
              ),
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      MooncakeIcons.cross,
                      size: 20,
                    ),
                    onPressed: _handleClose,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _handleClose() {
    Navigator.pop(context);
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final item = widget.photos[index];
    return PhotoViewGalleryPageOptions.customChild(
      child: item.isLocal
          ? Image(
              width: double.infinity,
              fit: BoxFit.cover,
              image: FileImage(File(item.uri)),
            )
          : CachedNetworkImage(
              width: double.infinity,
              fit: BoxFit.contain,
              imageUrl: item.uri,
              placeholder: (context, _) => LoadingIndicator(),
            ),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
    );
  }
}
