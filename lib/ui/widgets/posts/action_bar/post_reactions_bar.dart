import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/widgets/common/more_button.dart';

import 'add_reaction_button.dart';
import 'post_reaction_button.dart';

/// Represents the bar displaying the list of reactions that a post
/// has associated to itself.
class PostReactionsBar extends StatelessWidget {
  final Post post;
  final User user;
  final bool compact;

  const PostReactionsBar({
    Key key,
    @required this.post,
    @required this.user,
    this.compact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reactMap = groupBy<Reaction, String>(post.reactions, (r) => r.value);
    final showMore = compact && reactMap.length > 2;

    int itemCount = reactMap.length;
    if (showMore) {
      // First two reactions and the more buttons
      itemCount = 3;
    }

    // Add the add reaction button
    itemCount += 1;

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        separatorBuilder: (c, i) => SizedBox(width: 8),
        shrinkWrap: compact,
        itemBuilder: (_, index) {
          if (index == itemCount - 1) {
            return AddReactionButton(post: post);
          }

          // Button indicating there's more
          if (showMore && index == itemCount - 2) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MoreButton(),
              ],
            );
          }

          final entry = reactMap.entries.toList()[index];
          return PostReactionButton(post: post, user: user, entry: entry);
        },
      ),
    );
  }
}
