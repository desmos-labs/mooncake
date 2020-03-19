import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents a post like button that can be tapped to like a post if not
/// yet liked, or to remove a like if already liked.
class PostLikeAction extends StatelessWidget {
  final double size;

  const PostLikeAction({Key key, this.size = 24.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostListItemBloc, PostListItemState>(
      builder: (BuildContext context, PostListItemState state) {
        final icon = state.isLiked
            ? FaIcon(MooncakeIcons.heartFilled)
            : FaIcon(MooncakeIcons.heart);

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: size,
              width: size,
              child: IconButton(
                padding: EdgeInsets.all(0.0),
                iconSize: size,
                icon: icon,
                onPressed: () {
                  BlocProvider.of<PostListItemBloc>(context)
                      .add(AddOrRemoveLike());
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
