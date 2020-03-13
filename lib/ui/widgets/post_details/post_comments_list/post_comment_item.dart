import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

import 'post_comment_actions.dart';

/// Represents single item entry inside the list of post comments.
class PostCommentItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostListItemBloc, PostListItemState>(
      builder: (BuildContext context, PostListItemState state) {
        if (state is PostListItemLoading) {
          return Container();
        }

        final currentState = state as PostListItemLoaded;
        return Container(
          padding: PostsTheme.postItemPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              PostItemHeader(
                key: PostsKeys.postItemHeader(currentState.post.id),
                post: currentState.post,
              ),
              const SizedBox(height: PostsTheme.defaultPadding),
              Text(currentState.post.message),
              const SizedBox(height: PostsTheme.defaultPadding),
              PostCommentActions(),
            ],
          ),
        );
      },
    );
  }
}
