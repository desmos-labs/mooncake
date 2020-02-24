import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

import 'post_action_icon.dart';

/// Represents the icon that is use the tell how many comments a post has.
class PostCommentIcon extends StatelessWidget {
  final Post post;

  PostCommentIcon({this.post, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          post.allowsComments
              ? FontAwesomeIcons.comment
              : FontAwesomeIcons.commentSlash,
          color: PostsTheme.textColorVeryLight,
        ),
        SizedBox(width: 5.0),
        Text(
          post.commentsIds.length.toStringOrEmpty(),
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: PostsTheme.textColorVeryLight,
              ),
        )
      ],
    );
  }
}
