import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import './widgets/export.dart';

class ReactionsList extends StatefulWidget {
  final Post post;
  ReactionsList({
    @required this.post,
  });

  @override
  _ReactionsListState createState() => _ReactionsListState();
}

class _ReactionsListState extends State<ReactionsList> {
  static String SELECTED_ALL = 'all';
  String selectedFilter = SELECTED_ALL;

  void _handleFilterItemClick(String value) {
    setState(() {
      selectedFilter = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    int listReactionsLength = widget.post.reactions.length;
    List<Reaction> listReactions = widget.post.reactions.reversed.toList();

    if (selectedFilter != SELECTED_ALL) {
      listReactions = widget.post.reactions
          .where((reaction) => reaction.value == selectedFilter)
          .toList();
      listReactionsLength = listReactions.length;
    }

    return CustomScrollView(
      shrinkWrap: true,
      key: PageStorageKey<String>("reactions"),
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(bottom: 15),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            height: 55.0,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.post.reactionsCount.entries.toList().length + 1,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: 10,
                );
              },
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ReactionFilterItem(
                    display:
                        PostsLocalizations.of(context).translate(Messages.all),
                    value: SELECTED_ALL,
                    active: selectedFilter,
                    onClick: _handleFilterItemClick,
                  );
                }

                int reactionIndex = index - 1;
                final entry =
                    widget.post.reactionsCount.entries.toList()[reactionIndex];
                return ReactionFilterItem(
                  active: selectedFilter,
                  display: '${entry.key.value} ${entry.value}',
                  value: '${entry.key.value}',
                  onClick: _handleFilterItemClick,
                );
              },
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return PostReactionItem(
                reaction: listReactions[index],
              );
            },
            childCount: listReactionsLength,
          ),
        )
      ],
    );
  }
}
