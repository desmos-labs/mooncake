import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';

import 'post_content_image_item.dart';

/// Allows to properly visualize the image(s) associated with a post.
/// If only a single image is present, it will be shown full-width.
/// Otherwise, if more than one image is present, it will be displayed
/// as a grid of squared images.
class PostImagesPreviewer extends StatefulWidget {
  final Post post;

  const PostImagesPreviewer({
    Key key,
    @required this.post,
  }) : super(key: key);

  @override
  _PostImagesPreviewerState createState() => _PostImagesPreviewerState();
}

class _PostImagesPreviewerState extends State<PostImagesPreviewer> {
  int currentIndex = 0;
  final double indicatorSize = 6;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _imagesCarousel(),
        if (widget.post.images.length > 1) _imagesIndicator(),
      ],
    );
  }

  CarouselSlider _imagesCarousel() {
    return CarouselSlider(
      viewportFraction: 1.0,
      enableInfiniteScroll: false,
      onPageChanged: (index) => _onPageChanged(index),
      items: List.generate(widget.post.images.length, (index) {
        return PostContentImage(media: widget.post.images[index]);
      }),
    );
  }

  Column _imagesIndicator() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.post.images.length, (index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 2),
              height: indicatorSize,
              width: indicatorSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentIndex == index
                    ? Theme.of(context).accentColor
                    : Theme.of(context).accentColor.withOpacity(0.4),
              ),
            );
          }),
        ),
      ],
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
