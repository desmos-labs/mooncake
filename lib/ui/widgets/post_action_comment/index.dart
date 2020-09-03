import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:intl/intl.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the icon that is use the tell how many comments a post has.
class PostCommentAction extends StatelessWidget {
  final Post post;
  final double size;
  final Color color;

  const PostCommentAction({
    Key key,
    @required this.post,
    this.size = 24.0,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final comments = post.commentsIds ?? [];
    final countColor = color ?? Theme.of(context).iconTheme.color;

    return SizedBox(
      height: size,
      child: Row(
        children: <Widget>[
          Container(
            width: size,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: FaIcon(MooncakeIcons.comment, size: size, color: color),
              onPressed: () => _onTap(context),
            ),
          ),
          if (comments.isNotEmpty) _commentsCount(context, comments, countColor)
        ],
      ),
    );
  }

  Widget _commentsCount(
      BuildContext context, List<String> comments, Color color) {
    return Row(
      children: [
        SizedBox(width: size / 4),
        Text(
          NumberFormat.compact().format(comments.length),
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: color,
              ),
        ),
      ],
    );
  }

  void _onTap(BuildContext context) {
    BlocProvider.of<NavigatorBloc>(context).add(NavigateToCreatePost(post));
  }
}
