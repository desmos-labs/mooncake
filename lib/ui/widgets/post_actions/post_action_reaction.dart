import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents a single reaction button that allows the user to add a new
/// reaction or remove an existing one.
class PostReactionAction extends StatelessWidget {
  final Post post;
  final String reactionRune;
  final String reactionCode;
  final int reactionCount;

  const PostReactionAction({
    Key key,
    @required this.post,
    @required this.reactionRune,
    @required this.reactionCode,
    @required this.reactionCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostListItemBloc, PostListItemState>(
      builder: (BuildContext context, PostListItemState state) {
        final userReacted = post.reactions.containsFrom(
          state.user,
          reactionCode,
        );
        final textStyle = Theme.of(context).textTheme.bodyText2.copyWith(
              color: userReacted ? Theme.of(context).accentColor : null,
              fontWeight: userReacted ? FontWeight.bold : null,
            );

        return ActionChip(
          backgroundColor: Theme.of(context).primaryColorDark,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(reactionRune),
              SizedBox(width: 8),
              Text(reactionCount.toString(), style: textStyle)
            ],
          ),
          onPressed: () {
            BlocProvider.of<PostsListBloc>(context)
                .add(AddOrRemovePostReaction(post, reactionCode));
          },
          shape: StadiumBorder(
            side: BorderSide(
              color: userReacted
                  ? Theme.of(context).accentColor
                  : Colors.transparent,
            ),
          ),
        );
      },
    );
  }
}
