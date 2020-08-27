import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents a single row inside the list of post reactions.
class PostReactionItem extends StatelessWidget {
  final Reaction reaction;

  const PostReactionItem({Key key, this.reaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        BlocProvider.of<NavigatorBloc>(context)
            .add(NavigateToUserDetails(reaction.user))
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            AccountAvatar(size: 36, user: reaction.user),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                reaction.user.screenName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(reaction.value),
          ],
        ),
      ),
    );
  }
}
