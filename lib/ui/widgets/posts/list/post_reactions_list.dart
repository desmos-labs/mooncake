import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/blocs/export.dart';
import 'package:mooncake/ui/theme/theme.dart';

/// Represents the list of reactions that a post has associated to itself.
class PostReactionsList extends StatelessWidget {
  final String postId;

  const PostReactionsList({
    Key key,
    @required this.postId,
  })  : assert(postId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsBloc, PostsState>(
      builder: (context, postsState) {
        final state = postsState as PostsLoaded;
        final post = state.posts.firstBy(id: postId);
        if (post == null) {
          return Container();
        }

        final parser = EmojiParser();
        final reactMap =
            groupBy<Reaction, String>(post.reactions, (r) => r.value);

        return SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: reactMap.length,
              separatorBuilder: (c, i) => SizedBox(width: 8),
              itemBuilder: (_, index) {
                final reactEntry = reactMap.entries.toList()[index];
                final reacts = reactEntry.value;

                final reactValue = reacts[0].value;
                final emoji = parser.emojify(reactValue);
                final userReacted = _hasUserReacted(post, reactValue, state);

                return ActionChip(
                  label: Text("$emoji ${reacts.length}"),
                  onPressed: () {
                    _postReactionClicked(context, userReacted, reactValue);
                  },
                  backgroundColor:
                      userReacted ? PostsTheme.accentColorLight : null,
                );
              },
            ));
      },
    );
  }

  /// Handles the click on a post reaction
  void _postReactionClicked(
      BuildContext context, bool userReacted, String reactValue) {
    final bloc = BlocProvider.of<PostsBloc>(context);
    if (userReacted) {
      bloc.add(RemovePostReaction(postId, reactValue));
    } else {
      bloc.add(AddPostReaction(postId, reactValue));
    }
  }

  /// Tells if the user has reacted using the given [value] to the
  /// given [post].
  bool _hasUserReacted(Post post, String value, PostsLoaded state) {
    final userReact = Reaction(value: value, owner: state.address);
    return post.reactions.contains(userReact);
  }
}
