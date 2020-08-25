import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents a single reaction button that allows the user to add a new
/// reaction or remove an existing one.
class PostReactionAction extends StatelessWidget {
  final Post post;
  final String reactionValue;
  final String reactionCode;
  final int reactionCount;

  const PostReactionAction({
    Key key,
    @required this.post,
    @required this.reactionValue,
    @required this.reactionCode,
    @required this.reactionCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (BuildContext context, AccountState state) {
        final userReacted = post.reactions.containsFrom(
          (state as LoggedIn).user,
          reactionValue,
        );
        final textStyle = Theme.of(context).textTheme.bodyText2.copyWith(
              fontWeight: userReacted ? FontWeight.bold : null,
              color: userReacted ? Theme.of(context).colorScheme.primary : null,
            );

        final backgroundColor = userReacted
            ? Theme.of(context).colorScheme.primary.withOpacity(0.25)
            : ThemeColors.reactionBackground(context);

        return ActionChip(
          backgroundColor: backgroundColor,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(reactionValue),
              SizedBox(width: 8),
              Text(
                reactionCount.toString(),
                style: textStyle.copyWith(
                  fontSize: 10,
                ),
              )
            ],
          ),
          onPressed: () {
            BlocProvider.of<PostsListBloc>(context)
                .add(AddOrRemovePostReaction(post, reactionValue));
          },
        );
      },
    );
  }
}
