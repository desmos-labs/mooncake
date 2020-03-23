import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

import 'post_likes_counter.dart';

/// Represents the action bar containing all the actions that can be performed
/// from a single post.
class PostActionsBar extends StatelessWidget {
  static const ICON_SIZE = 16.0;
  static const ICON_SPACING = 16.0;

  final Post post;
  const PostActionsBar({
    Key key,
    @required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostListItemBloc, PostListItemState>(
      builder: (BuildContext context, PostListItemState state) {
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      PostLikeAction(
                        post: post,
                        isLiked: state.user.hasLiked(post),
                      ),
                      const SizedBox(width: ThemeSpaces.actionBarSpacer),
                      PostCommentAction(post: post),
                      const SizedBox(width: ThemeSpaces.actionBarSpacer),
                      PostAddReactionAction(post: post),
                    ],
                  ),
                ),
                if (post.likes.length > 0) PostLikesCounter(post: post),
              ],
            ),
          ],
        );
      },
    );
  }
}
