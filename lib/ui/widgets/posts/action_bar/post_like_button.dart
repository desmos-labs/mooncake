import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents a post like button that can be tapped to like a post if not
/// yet liked, or to remove a like if already liked.
class PostLikeAction extends StatefulWidget {
  final User user;
  final Post post;

  const PostLikeAction({
    Key key,
    @required this.user,
    @required this.post,
  }) : super(key: key);

  @override
  _PostLikeActionState createState() => _PostLikeActionState();
}

class _PostLikeActionState extends State<PostLikeAction> {
  bool isSelected = false;
  bool isLiked = false;

  @override
  void initState() {
    // Search for any like reaction from the user
    isLiked = widget.post.reactions
        .where((r) => r.owner == widget.user.address && r.isLike)
        .isNotEmpty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final likesCount =
        widget.post.reactions?.where((e) => e.isLike)?.length ?? 0;

    final iconColor = Colors.red;
    IconData iconData = FontAwesomeIcons.heart;
    if (isLiked || isSelected) {
      iconData = FontAwesomeIcons.solidHeart;
    }

    final icon = Icon(iconData, color: iconColor);

    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            // ignore: close_sinks
            final bloc = BlocProvider.of<PostsBloc>(context);
            bloc.add(AddOrRemovePostReaction(
                postId: widget.post.id, reaction: ":+1:"));
          },
          onTapDown: (_) => setState(() {
            isSelected = true;
          }),
          onTapUp: (_) => setState(() {
            isSelected = false;
          }),
          onTapCancel: () => setState(() {
            isSelected = false;
          }),
          child: icon,
        ),
        const SizedBox(width: 5.0),
        Text(
          likesCount.toStringOrEmpty(),
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: PostsTheme.textColorVeryLight,
              ),
        )
      ],
    );
  }
}
