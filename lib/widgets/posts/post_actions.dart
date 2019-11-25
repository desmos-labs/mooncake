import 'package:desmosdemo/blocs/blocs.dart';
import 'package:desmosdemo/models/models.dart';
import 'package:desmosdemo/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Represents the action bar containing all the actions that can be performed
/// from a single post.
class PostActionsBar extends StatelessWidget {
  final Post post;

  const PostActionsBar({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        PostAction(
          icon: FontAwesomeIcons.comments,
          value: '${post.commentsIds.length > 0 ? post.commentsIds.length : ''}',
        ),
        SizedBox(width: 8),
        PostAction(
          icon:
              post.liked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
          action: () {
            if (post.liked) {
              BlocProvider.of<PostsBloc>(context).add(UnlikePost(post));
            } else {
              BlocProvider.of<PostsBloc>(context).add(LikePost(post));
            }
          },
          value: '${post.likes.length > 0 ? post.likes.length : ''}',
        ),
      ],
    );
  }
}
