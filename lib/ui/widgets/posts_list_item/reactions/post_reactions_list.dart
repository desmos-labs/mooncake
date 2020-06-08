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
class PostReactionsList extends StatefulWidget {
  final Post post;

  const PostReactionsList({
    Key key,
    @required this.post,
  }) : super(key: key);

  @override
  _PostReactionsListState createState() => _PostReactionsListState();
}

class _PostReactionsListState extends State<PostReactionsList> {
  bool actionBarExpanded = false;

  @override
  Widget build(BuildContext context) {
    final reactsCount = widget.post.reactionsCount.length;

    // Tells then the "More" button should be visible
    final showMore = reactsCount > 4;

    int itemCount = reactsCount;
    if (showMore && !actionBarExpanded) {
      // There should be the max number of items per row, as the last one
      // will be the "More" button
      itemCount = 4;
    } else if (showMore && actionBarExpanded) {
      // There should be all the items visible, plus the "More" button
      itemCount = reactsCount + 1;
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Wrap(
            spacing: 6.0,
            alignment: WrapAlignment.start,
            children: List.generate(itemCount, (index) {
              if (showMore && index == itemCount - 1) {
                return IconButton(
                  icon: Icon(MooncakeIcons.more, size: 16),
                  onPressed: () => _triggerExpansion(context),
                );
              }

              final entry = widget.post.reactionsCount.entries.toList()[index];
              return PostReactionAction(
                post: widget.post,
                reactionCode: entry.key.code,
                reactionValue: entry.key.value,
                reactionCount: entry.value,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _triggerExpansion(BuildContext context) {
    setState(() {
      actionBarExpanded = !actionBarExpanded;
    });
  }
}
