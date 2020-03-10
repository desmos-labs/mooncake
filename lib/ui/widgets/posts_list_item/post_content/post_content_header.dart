import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/theme/theme.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Contains the info that are shown on top of a [PostListItem]. The following
/// data are :
/// - the owner o the post
/// - the block height at which the post has been created
///
/// TODO: Add the username (maybe using Starnames?)
class PostItemHeader extends StatelessWidget {
  final Post post;

  PostItemHeader({
    @required this.post,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final diff = DateTime.now().difference(post.dateTime);
    final timeAgo = DateTime.now().subtract(diff);

    return Row(
      children: <Widget>[
        // User picture
        UserAvatar(user: post.owner),

        // Spacer
        const SizedBox(width: PostsTheme.defaultPadding),

        // Username and time ago
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                post.owner.screenName,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
              ),
              Text(
                timeago.format(timeAgo),
                style: Theme.of(context).textTheme.caption.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
              )
            ],
          ),
        ),

        // Spacer
        const SizedBox(width: PostsTheme.defaultPadding),

        // More button
        // TODO: Implement this again
//        IconButton(
//          icon: Icon(MooncakeIcons.more, size: 20),
//          tooltip: PostsLocalizations.of(context).postActionsButtonCaption,
//          onPressed: () {},
//        )
      ],
    );
  }
}
