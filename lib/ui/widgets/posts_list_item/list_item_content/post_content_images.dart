import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

import 'post_content_image_item.dart';

/// Allows to properly visualize the image(s) associated with a post.
/// If only a single image is present, it will be shown full-width.
/// Otherwise, if more than one image is present, it will be displayed
/// as a grid of squared images.
class PostImagesPreviewer extends StatelessWidget {
  final double indicatorSize = 6;
  final Post post;

  const PostImagesPreviewer({
    Key key,
    @required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostImagesCarouselBloc>(
      create: (_) => PostImagesCarouselBloc.create(),
      child: BlocBuilder<PostImagesCarouselBloc, PostImagesCarouselState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _imagesCarousel(context),
              if (post.images.length > 1) _imagesIndicator(state, context),
            ],
          );
        },
      ),
    );
  }

  CarouselSlider _imagesCarousel(BuildContext context) {
    return CarouselSlider(
      viewportFraction: 1.0,
      enableInfiniteScroll: false,
      onPageChanged: (index) => _onPageChanged(context, index),
      items: List.generate(post.images.length, (index) {
        return PostContentImage(media: post.images[index]);
      }),
    );
  }

  Column _imagesIndicator(PostImagesCarouselState state, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(post.images.length, (index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 2),
              height: indicatorSize,
              width: indicatorSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: state.currentIndex == index
                    ? Theme.of(context).accentColor
                    : Theme.of(context).accentColor.withOpacity(0.4),
              ),
            );
          }),
        ),
      ],
    );
  }

  void _onPageChanged(BuildContext context, int index) {
    BlocProvider.of<PostImagesCarouselBloc>(context).add(ImageChanged(index));
  }
}
