import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the icon that is use the tell how many comments a post has.
class PostCommentAction extends StatelessWidget {
  final Post post;
  final double size;

  const PostCommentAction({
    Key key,
    @required this.post,
    this.size = 24.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final comments = post.commentsIds ?? [];
    return SizedBox(
      height: size,
      child: Row(
        children: <Widget>[
          Container(
            width: size,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: FaIcon(MooncakeIcons.comment, size: size),
              onPressed: () => _onTap(context),
            ),
          ),
          if (comments.isNotEmpty) SizedBox(width: size / 4),
          if (comments.isNotEmpty)
            Text(
              comments.length.toString(),
              style: Theme.of(context).accentTextTheme.bodyText2,
            ),
        ],
      ),
    );
  }

  void _onTap(BuildContext context) {
    BlocProvider.of<NavigatorBloc>(context).add(NavigateToCreatePost(post));
  }
}
