import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents a single reaction button that allows the user to add a new
/// reaction or remove an existing one.
class PostReactionButton extends StatelessWidget {
  final Post post;
  final User user;
  final MapEntry<String, List<Reaction>> entry;

  const PostReactionButton({
    Key key,
    @required this.post,
    @required this.user,
    @required this.entry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reacts = entry.value;
    final userReacted = _hasUserReacted();

    final textStyle = Theme.of(context).textTheme.bodyText2.copyWith(
          color: userReacted ? Theme.of(context).accentColor : null,
          fontWeight: userReacted ? FontWeight.bold : null,
        );

    return ActionChip(
      backgroundColor:
          userReacted ? PostsTheme.accentColor.withAlpha(50) : null,
      label: Row(
        children: <Widget>[
          Text(entry.key),
          SizedBox(width: 8),
          Text(
            reacts.length.toString(),
            style: textStyle,
          )
        ],
      ),
      onPressed: () {
        // ignore: close_sinks
        final bloc = BlocProvider.of<PostsBloc>(context);
        bloc.add(AddOrRemovePostReaction(
          postId: post.id,
          reaction: entry.key,
        ));
      },
      shape: StadiumBorder(
        side: BorderSide(
          color: userReacted ? Theme.of(context).accentColor : Colors.grey[400],
        ),
      ),
    );
  }

  /// Tells if the user has reacted using the given [value] to the
  /// given [post].
  bool _hasUserReacted() {
    final userReact = Reaction(value: entry.key, owner: user.address);
    return post.reactions.contains(userReact);
  }
}
