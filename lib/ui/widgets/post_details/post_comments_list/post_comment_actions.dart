import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the actions that are visualized inside each single comment item.
class PostCommentActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostListItemBloc, PostListItemState>(
      builder: (BuildContext context, PostListItemState state) {
        if (state is PostListItemLoading) {
          return Container();
        }

        final iconSize = 20.0;
        final currentState = state as PostListItemLoaded;
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            PostCommentAction(size: iconSize),
            SizedBox(width: iconSize),
            PostLikeAction(size: iconSize),
          ],
        );
      },
    );
  }
}
