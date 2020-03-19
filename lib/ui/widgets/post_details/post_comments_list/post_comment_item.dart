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
        return Container(
          padding: PostsTheme.postItemPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              PostItemHeader(
                key: PostsKeys.postItemHeader(state.post.id),
                post: state.post,
              ),
              const SizedBox(height: PostsTheme.defaultPadding),
              Text(state.post.message),
              const SizedBox(height: PostsTheme.defaultPadding),
              PostCommentActions(),
            ],
          ),
        );
      },
    );
  }
}
