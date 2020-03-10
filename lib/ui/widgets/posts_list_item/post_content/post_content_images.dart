import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/theme/theme.dart';

/// Allows to properly visualize the image(s) associated with a post.
/// If only a single image is present, it will be shown full-width.
/// Otherwise, if more than one image is present, it will be displayed
/// as a grid of squared images.
class PostImagesPreviewer extends StatelessWidget {
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

    Widget child;
    if (images.length == 1) {
      child = Image(
        width: double.infinity,
        image: NetworkImage(
          images[0].url,
        ),
      );
    }

    if (images.length > 1) {
      child = GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
        children: List.generate(images.length, (index) {
          return Image(
            width: double.infinity,
            fit: BoxFit.cover,
            image: NetworkImage(
              images[index].url,
            ),
          );
        }),
      );
    }

    return child;
  }
}
