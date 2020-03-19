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
        return Row(
          children: <Widget>[
            FaIcon(MooncakeIcons.comment, size: size),
            if (state.post.commentsIds.isNotEmpty)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(width: size / 4),
                  Text(
                    state.post.commentsIds.length.toStringOrEmpty(),
                    style: Theme.of(context).accentTextTheme.bodyText2,
                  )
                ],
              ),
          ],
        );
      },
    );
  }
}
