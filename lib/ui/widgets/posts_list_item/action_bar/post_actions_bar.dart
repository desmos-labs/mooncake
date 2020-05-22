import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

import 'post_likes_counter.dart';

/// Represents the action bar containing all the actions that can be performed
/// from a single post.
class PostActionsBar extends StatelessWidget {
  static const ICON_SPACING = 8.0;

  final Post post;

  const PostActionsBar({Key key, @required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (BuildContext context, AccountState state) {
        return Row(
          children: <Widget>[
            Expanded(
              child: post.likes.length > 0
                  ? PostLikesCounter(post: post)
                  : Container(),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: PostLikeAction(
                      post: post,
                      isLiked: (state as LoggedIn).user.hasLiked(post),
                    ),
                  ),
                  const SizedBox(width: ICON_SPACING),
                  Expanded(child: PostCommentAction(post: post)),
                  const SizedBox(width: ICON_SPACING),
                  Expanded(child: PostAddReactionAction(post: post)),
                ],
              ),
            ),

          ],
        );
      },
    );
  }

  void _openPostDetails(BuildContext context) {
    BlocProvider.of<NavigatorBloc>(context)
        .add(NavigateToPostDetails(context, post.id));
  }
}
