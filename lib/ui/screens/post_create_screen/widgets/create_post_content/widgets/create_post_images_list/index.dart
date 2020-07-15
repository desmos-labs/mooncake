import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/screens/post_create_screen/blocs/export.dart';
import 'widgets/export.dart';

/// Contains the list of images associated to a post.
class CreatePostImagesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return BlocBuilder<PostInputBloc, PostInputState>(
          builder: (context, state) {
            if (state.medias.isEmpty) {
              return Container();
            }

            final spacer = 10.0;
            final imageSize = (constraints.maxWidth - (2 * (spacer + 0.1))) / 3;

            return Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Wrap(
                    runSpacing: spacer,
                    spacing: spacer,
                    children: List.generate(state.medias.length, (index) {
                      final image = state.medias[index];
                      return CreatePostImageItem(size: imageSize, media: image);
                    }),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
