import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents a single row inside the list of post reactions.
class PostReactionItem extends StatelessWidget {
  final Reaction reaction;

  const PostReactionItem({Key key, this.reaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: PostsTheme.postItemPadding,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          UserAvatar(user: reaction.user),
          const SizedBox(width: PostsTheme.defaultPadding),
          Expanded(
            child: Text(
              reaction.user.screenName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: PostsTheme.defaultPadding),
          Text(reaction.value),
        ],
      ),
    );
  }
}
