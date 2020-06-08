import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents a post like button that can be tapped to like a post if not
/// yet liked, or to remove a like if already liked.
class PostLikeAction extends StatelessWidget {
  final double size;

  final bool isLiked;
  final Post post;

  const PostLikeAction({
    Key key,
    @required this.isLiked,
    @required this.post,
    this.size = 24.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final icon = isLiked
        ? Icon(MooncakeIcons.heartF, size: size)
        : Icon(MooncakeIcons.heart, size: size);

    return SizedBox(
      height: size,
      child: Row(
        children: <Widget>[
          Container(
            width: size,
            child: IconButton(
              padding: EdgeInsets.zero,
              color: Theme.of(context).primaryColor,
              icon: icon,
              onPressed: () => _onPressed(context),
            ),
          ),
          if (post.likes.isNotEmpty) _likesCount(context, post.likes)
        ],
      ),
    );
  }

  Widget _likesCount(BuildContext context, List<Reaction> likes) {
    return Row(
      children: [
        SizedBox(width: size / 4),
        Text(
          NumberFormat.compact().format(likes.length),
          style: Theme.of(context).textTheme.bodyText2.copyWith(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  void _onPressed(BuildContext context) {
    BlocProvider.of<PostsListBloc>(context).add(AddOrRemoveLike(post));
  }
}
