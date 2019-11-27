import 'package:desmosdemo/models/models.dart';
import 'package:desmosdemo/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

typedef LikeStatusChanged = Function(bool);

/// Represents the action bar containing all the actions that can be performed
/// from a single post.
class PostActionsBar extends StatelessWidget {
  final Post post;
  final LikeStatusChanged onLikedChanged;

  const PostActionsBar({
    Key key,
    @required this.post,
    @required this.onLikedChanged,
  })  : assert(post != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sync
    final syncIcon =
        post.synced ? FontAwesomeIcons.checkCircle : FontAwesomeIcons.circle;

    // Comments
    final commentsNumber = post.commentsIds.length;
    final commentsText = '${commentsNumber > 0 ? commentsNumber : ''}';

    // Likes
    final likeIcon =
        post.liked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart;
    final likeText = '${post.likes.length > 0 ? post.likes.length : ''}';

    return Row(
      children: <Widget>[
        Icon(syncIcon, size: 16),
        SizedBox(width: 16),
        PostAction(icon: FontAwesomeIcons.comments, value: commentsText),
        SizedBox(width: 16),
        PostAction(
          icon: likeIcon,
          value: likeText,
          action: () => onLikedChanged(!post.liked),
        ),
      ],
    );
  }
}
