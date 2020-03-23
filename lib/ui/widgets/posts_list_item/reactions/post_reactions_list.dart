import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the bar displaying the list of reactions that a post
/// has associated to itself.
/// If [compact] is set to `true`, the list will be chopped to
/// at most two items.
class PostReactionsList extends StatelessWidget {
  final double itemHeight = 40;

  final Post post;
  const PostReactionsList({
    Key key,
    @required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostListItemBloc, PostListItemState>(
      builder: (BuildContext context, PostListItemState state) {
        // Filter the likes as they are showed independently
        final reactions = post.reactions
            .where((r) => !r.isLike)
            .where((element) => element.rune.runes.length == 1);
        final reactMap = groupBy<Reaction, String>(reactions, (r) => r.rune);

        // Compute the number of items per row
        final singleRowItems = MediaQuery.of(context).size.width ~/ 70;

        // Tells then the "More" button should be visible
        final showMore = reactMap.length > singleRowItems;

        int itemCount = reactMap.length;
        if (showMore && !state.actionBarExpanded) {
          // There should be the max number of items per row, as the last one
          // will be the "More" button
          itemCount = singleRowItems;
        }

        if (showMore && state.actionBarExpanded) {
          // There should be all the items visible, plus the "More" button
          itemCount = reactMap.length + 1;
        }

        return Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Wrap(
                spacing: ThemeSpaces.actionBarSpacer,
                alignment: WrapAlignment.start,
                children: List.generate(itemCount, (index) {
                  if (showMore && index == itemCount - 1) {
                    return IconButton(
                      icon: Icon(MooncakeIcons.moreHorizontal, size: 16),
                      onPressed: () => _triggerExpansion(context),
                    );
                  }

                  final entry = reactMap.entries.toList()[index];
                  return PostReactionAction(
                    post: post,
                    reactionCode: entry.value[0].code,
                    reactionRune: entry.value[0].rune,
                    reactionCount: entry.value.length,
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  void _triggerExpansion(BuildContext context) {
    BlocProvider.of<PostListItemBloc>(context)
        .add(ChangeReactionBarExpandedState());
  }
}
