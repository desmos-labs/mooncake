import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents a single reaction button that allows the user to add a new
/// reaction or remove an existing one.
class PostReactionButton extends StatelessWidget {
  final String reaction;
  final int reactionCount;

  const PostReactionButton({
    Key key,
    @required this.reaction,
    @required this.reactionCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostListItemBloc, PostListItemState>(
      builder: (context, state) {
        final currentState = (state as PostListItemLoaded);

        final userReacted = currentState.hasUserReactedWith(reaction);
        final textStyle = Theme.of(context).textTheme.bodyText2.copyWith(
              color: userReacted ? Theme.of(context).accentColor : null,
              fontWeight: userReacted ? FontWeight.bold : null,
            );

        return ActionChip(
          backgroundColor:
              userReacted ? PostsTheme.accentColor.withAlpha(50) : null,
          label: Row(
            children: <Widget>[
              Text(reaction),
              SizedBox(width: 8),
              Text(reactionCount.toString(), style: textStyle)
            ],
          ),
          onPressed: () {
            // ignore: close_sinks
            final bloc = BlocProvider.of<PostListItemBloc>(context);
            bloc.add(AddOrRemovePostReaction(reaction: reaction));
          },
          shape: StadiumBorder(
            side: BorderSide(
              color: userReacted
                  ? Theme.of(context).accentColor
                  : Colors.grey[400],
            ),
          ),
        );
      },
    );
  }
}
