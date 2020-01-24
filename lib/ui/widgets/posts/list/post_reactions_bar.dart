import 'package:collection/collection.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/blocs/export.dart';
import 'package:mooncake/ui/theme/theme.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the bar displaying the list of reactions that a post
/// has associated to itself.
class PostReactionsBar extends StatelessWidget {
  final String postId;

  const PostReactionsBar({
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

        final validReactions =
            post.reactions.where((r) => r.value.runes.length == 1).toList();
        final reactMap =
            groupBy<Reaction, String>(validReactions, (r) => r.value);

        return SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: reactMap.length + 1,
              separatorBuilder: (c, i) => SizedBox(width: 8),
              itemBuilder: (_, index) {
                if (index == 0) {
                  return _addEmojiButton(context, postId);
                }

                final reactEntry = reactMap.entries.toList()[index - 1];
                final reacts = reactEntry.value;

                final reactValue = reacts[0].value;
                final userReacted = _hasUserReacted(post, reactValue, state);

                final textStyle = Theme.of(context).textTheme.body1.copyWith(
                      color: userReacted ? Theme.of(context).accentColor : null,
                      fontWeight: userReacted ? FontWeight.bold : null,
                    );

                return ActionChip(
                  label: Row(
                    children: <Widget>[
                      Text(reactValue),
                      SizedBox(width: 8),
                      Text(
                        reacts.length.toString(),
                        style: textStyle,
                      )
                    ],
                  ),
                  onPressed: () {
                    _postReactionClicked(context, userReacted, reactValue);
                  },
                  backgroundColor:
                      userReacted ? PostsTheme.accentColor.withAlpha(50) : null,
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: userReacted
                          ? Theme.of(context).accentColor
                          : Colors.grey[400],
                    ),
                  ),
                );
              },
            ));
      },
    );
  }

  Widget _addEmojiButton(BuildContext context, String postId) {
    return ActionChip(
      shape: StadiumBorder(
        side: BorderSide(
          color: Colors.grey[400],
        ),
      ),
      label: Icon(FontAwesomeIcons.plus, size: 16),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext buildContext) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  EmojiPicker(
                    onEmojiSelected: (emoji, character) {
                      final bloc = BlocProvider.of<PostsBloc>(buildContext);
                      bloc.add(AddPostReaction(postId, emoji.emoji));
                      Navigator.pop(buildContext);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Handles the click on a post reaction
  void _postReactionClicked(
    BuildContext context,
    bool userReacted,
    String reactValue,
  ) {
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
