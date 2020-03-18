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
    // Filter all the non-images medias
    final images = post.medias?.where((element) => element.isImage)?.toList();

    // No images to display
    if (images == null || images.isEmpty) {
      return Container();
    }

    return BlocProvider<PostImagesCarouselBloc>(
      create: (context) => PostImagesCarouselBloc.create(),
      child: BlocBuilder<PostImagesCarouselBloc, PostImagesCarouselState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CarouselSlider(
                viewportFraction: 1.0,
                enableInfiniteScroll: false,
                onPageChanged: (index) => _onPageChanged(context, index),
                items: List.generate(images.length, (index) {
                  return PostContentImage(media: images[index]);
                }),
              ),
              if (images.length > 1)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(images.length, (index) {
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
                ),
            ],
          );
        },
      ),
    );
  }

  void _onPageChanged(BuildContext context, int index) {
    BlocProvider.of<PostImagesCarouselBloc>(context).add(ImageChanged(index));
  }
}
