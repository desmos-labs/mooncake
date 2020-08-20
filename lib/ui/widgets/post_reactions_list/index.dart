import 'package:flutter/material.dart';
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
    final int reactsCount = widget.post.reactionsCount.length;

    List<Widget> _listReactions() {
      int count = 0;
      if (actionBarExpanded) {
        count = reactsCount;
      } else {
        count = reactsCount > 5 ? 5 : reactsCount;
      }

      List<Widget> results = [];
      for (var i = 0; i < count; i++) {
        final entry = widget.post.reactionsCount.entries.toList()[i];
        results.add(
          PostReactionAction(
            post: widget.post,
            reactionCode: entry.key.code,
            reactionValue: entry.key.value,
            reactionCount: entry.value,
          ),
        );
      }

      if (reactsCount > 5) {
        results.add(
          IconButton(
            icon: Icon(MooncakeIcons.more, size: 13),
            onPressed: () => _triggerExpansion(context),
          ),
        );
      }

      return results;
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Wrap(spacing: 4.0, alignment: WrapAlignment.start, children: [
            ..._listReactions(),
          ]),
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
