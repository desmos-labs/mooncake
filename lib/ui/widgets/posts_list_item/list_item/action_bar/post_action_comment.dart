import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the icon that is use the tell how many comments a post has.
class PostCommentAction extends StatelessWidget {
  final double size;

  const PostCommentAction({Key key, this.size = 24.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostListItemBloc, PostListItemState>(
      builder: (BuildContext context, PostListItemState state) {
        final currentState = (state as PostListItemLoaded);
        return Row(
          children: <Widget>[
            FaIcon(
              MooncakeIcons.comment,
              color: ThemeColors.textColorLight,
              size: size,
            ),
            SizedBox(width: size / 4),
            if (currentState.post.commentsIds.isNotEmpty)
              Text(
                currentState.post.commentsIds.length.toStringOrEmpty(),
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: ThemeColors.textColorLight,
                    ),
              )
          ],
        );
      },
    );
  }
}
