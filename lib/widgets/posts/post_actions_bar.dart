import 'package:desmosdemo/blocs/blocs.dart';
import 'package:desmosdemo/models/models.dart';
import 'package:desmosdemo/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Represents the action bar containing all the actions that can be performed
/// from a single post.
class PostActionsBar extends StatelessWidget {
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

        final post = (state as PostsLoaded).posts.findById(postId);
        return Row(
          children: <Widget>[
            Icon(
              post.synced
                  ? FontAwesomeIcons.checkCircle
                  : FontAwesomeIcons.circle,
              size: 16,
            ),
            SizedBox(width: 16),
            PostAction(
              icon: FontAwesomeIcons.comments,
              value: post.commentsIds.length.toStringOrEmpty(),
            ),
            SizedBox(width: 16),
            PostAction(
              icon: post.liked
                  ? FontAwesomeIcons.solidHeart
                  : FontAwesomeIcons.heart,
              value: post.likes.length.toStringOrEmpty(),
              action: () {
                final id = post.id;
                // ignore: close_sinks
                final bloc = BlocProvider.of<PostsBloc>(context);
                bloc.add(post.liked ? UnlikePost(id) : LikePost(id));
              },
            ),
          ],
        );
      },
    );
  }
}
