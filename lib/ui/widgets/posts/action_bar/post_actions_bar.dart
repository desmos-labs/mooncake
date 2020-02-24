import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/widgets/posts/action_bar/post_like_button.dart';

import 'post_reactions_bar.dart';

/// Represents the action bar containing all the actions that can be performed
/// from a single post.
class PostActionsBar extends StatelessWidget {
  static const ICON_SIZE = 16.0;
  static const ICON_SPACING = 16.0;

  final Post post;
  final User user;

  const PostActionsBar({
    Key key,
    @required this.post,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: PostsTheme.defaultPadding),
        Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  PostLikeAction(post: post, user: user),
                  const SizedBox(width: PostsTheme.defaultPadding),
                  PostCommentIcon(post: post),
                ],
              ),
            ),
            PostReactionsBar(
              key: PostsKeys.postsReactionBar(post.id),
              post: post,
              user: user,
              compact: true,
            )
          ],
        ),
      ],
    );
  }
}
