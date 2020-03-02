import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

import 'post_action_like.dart';
import 'post_action_comment.dart';
import 'post_action_add_reaction.dart';
import 'reactions/export.dart';

/// Represents the action bar containing all the actions that can be performed
/// from a single post.
class PostActionsBar extends StatelessWidget {
  static const ICON_SIZE = 16.0;
  static const ICON_SPACING = 16.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostListItemBloc, PostListItemState>(
      builder: (BuildContext context, PostListItemState state) {
        final currentState = (state as PostListItemLoaded);
        return Column(
          children: <Widget>[
            const SizedBox(height: PostsTheme.defaultPadding),
            Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            /// Likes
                            PostLikeAction(),
                            const SizedBox(width: PostsTheme.defaultPadding),
                            PostCommentAction(),
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          if (!currentState.actionBarExpanded)
                            PostReactionsList(compact: true),
                          if (currentState.showMoreButton)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: MoreButton(
                                onTap: () => _onMoreTap(context),
                              ),
                            ),
                          AddReactionAction(),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            if (currentState.actionBarExpanded)
              PostReactionsList(compact: false),
          ],
        );
      },
    );
  }

  void _onMoreTap(BuildContext context) {
    // ignore: close_sinks
    final bloc = BlocProvider.of<PostListItemBloc>(context);
    bloc.add(ChangeReactionBarExpandedState());
  }
}
