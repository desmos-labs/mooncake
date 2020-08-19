import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'widgets/export.dart';

/// Represents the item that the user should tap when wanting to add a
/// reaction to a post.
class PostAddReactionAction extends StatelessWidget {
  final double size;
  final Post post;
  final Color color;

  const PostAddReactionAction({
    Key key,
    @required this.post,
    this.size = 24.0,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // wingman
    // final reactions = post.reactions.where((e) => !e.isLike).toList();
    final reactions = post.reactions;
    final countColor =
        color != null ? color : Theme.of(context).iconTheme.color;
    return SizedBox(
      height: size,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: size,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(MooncakeIcons.reaction, size: size, color: color),
              onPressed: () => _onTap(context),
            ),
          ),
          // wingman
          // if (reactions.isNotEmpty)
          //   _reactionsCount(context, reactions, countColor)
        ],
      ),
    );
  }

  Widget _reactionsCount(
      BuildContext context, List<Reaction> reactions, Color color) {
    return Row(
      children: [
        SizedBox(width: size / 4),
        Text(
          NumberFormat.compact().format(reactions.length),
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: color,
              ),
        ),
      ],
    );
  }

  void _onTap(BuildContext context) {
    showEmojiPicker(
      context: context,
      onEmojiSelected: (emoji, _) => _onEmojiSelected(context, emoji),
    );
  }

  void _onEmojiSelected(BuildContext context, Emoji emoji) {
    BlocProvider.of<PostsListBloc>(context)
        .add(AddOrRemovePostReaction(post, emoji.emoji));
    BlocProvider.of<NavigatorBloc>(context).add(GoBack());
  }
}
