import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

/// Represents the action bar containing all the actions that can be performed
/// from a single post.
class PostActionsBar extends StatelessWidget {
  static const ICON_SIZE = 16.0;
  static const ICON_SPACING = 16.0;

  final String postId;

  const PostActionsBar({Key key, @required this.postId})
      : assert(postId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsBloc, PostsState>(
      builder: (context, state) {
        // Make sure we have loaded the posts properly
        assert(state is PostsLoaded);

        final post = (state as PostsLoaded).posts.firstBy(id: postId);
        IconData statusIcon = FontAwesomeIcons.circle;
        if (post.status.value == PostStatusValue.SYNCING) {
          statusIcon = FontAwesomeIcons.dotCircle;
        } else if (post.status.value == PostStatusValue.SYNCED) {
          statusIcon = FontAwesomeIcons.checkCircle;
        } else if (post.status.value == PostStatusValue.ERRORED) {
          statusIcon = FontAwesomeIcons.timesCircle;
        }

        final showFormatter = DateFormat.yMMMd().add_Hm();

        return Row(
          children: <Widget>[
            Icon(statusIcon, size: ICON_SIZE),
            SizedBox(width: ICON_SPACING / 2),
            Text(showFormatter.format(post.dateTime)),
            SizedBox(width: ICON_SPACING),
            PostAction(
              icon: post.allowsComments
                  ? FontAwesomeIcons.comment
                  : FontAwesomeIcons.commentSlash,
              value: post.commentsIds.length.toStringOrEmpty(),
            ),
            SizedBox(width: ICON_SPACING),
//            PostAction(
//              icon: post.liked
//                  ? FontAwesomeIcons.solidHeart
//                  : FontAwesomeIcons.heart,
//              value: post.likes.length.toStringOrEmpty(),
//              action: () {
//                final id = post.id;
//                // ignore: close_sinks
//                final bloc = BlocProvider.of<PostsBloc>(context);
//                bloc.add(post.liked ? UnlikePost(id) : LikePost(id));
//              },
//            ),
          ],
        );
      },
    );
  }
}
