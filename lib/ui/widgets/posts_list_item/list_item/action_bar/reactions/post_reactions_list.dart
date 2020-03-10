import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

import 'button_generic_reaction.dart';

/// Represents the bar displaying the list of reactions that a post
/// has associated to itself.
/// If [compact] is set to `true`, the list will be chopped to
/// at most two items.
class PostReactionsList extends StatelessWidget {
  final bool compact;

  const PostReactionsList({
    Key key,
    this.compact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostListItemBloc, PostListItemState>(
      builder: (context, state) {
        final currentState = (state as PostListItemLoaded);

        // Emoji parser
        final parser = EmojiParser();

        // Filter the likes as they are showed independently
        final reactions = currentState.post.reactions
            .where((r) => !r.isLike)
            .map((r) => r.copyWith(value: parser.emojify(r.value)))
            .where((element) => element.value.runes.length == 1);
        final reactMap = groupBy<Reaction, String>(reactions, (r) => r.value);

        // Max 2 items if is compact and with a length more than 2
        final itemCount = reactMap.length > 2 && compact ? 2 : reactMap.length;

        return SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: itemCount,
            separatorBuilder: (c, i) => SizedBox(
              width: ThemeSpaces.actionBarSpacer,
            ),
            shrinkWrap: compact,
            itemBuilder: (_, index) {
              final entry = reactMap.entries.toList()[index];
              return PostReactionButton(
                reaction: entry.key,
                reactionCount: entry.value.length,
              );
            },
          ),
        );
      },
    );
  }
}
