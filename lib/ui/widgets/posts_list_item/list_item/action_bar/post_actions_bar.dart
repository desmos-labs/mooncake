import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

import 'post_action_add_reaction.dart';
import 'post_action_comment.dart';
import 'post_action_like.dart';
import 'post_likes_counter.dart';

/// Represents the action bar containing all the actions that can be performed
/// from a single post.
class PostActionsBar extends StatelessWidget {
  static const ICON_SIZE = 16.0;
  static const ICON_SPACING = 16.0;

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
                    PostLikeAction(),
                    const SizedBox(width: ThemeSpaces.actionBarSpacer),
                    PostCommentAction(),
                    const SizedBox(width: ThemeSpaces.actionBarSpacer),
                    AddReactionAction(),
                  ],
                ),
              ),
              if (state.likesCount > 0) PostLikesCounter(),
            ],
          ),
        ],
      );
    });
  }
}
