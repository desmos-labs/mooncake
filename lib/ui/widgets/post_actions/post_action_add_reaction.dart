import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mooncake/entities/emojis/export.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the item that the user should tap when wanting to add a
/// reaction to a post.
class PostAddReactionAction extends StatelessWidget {
  final double size;

  final Post post;

  const PostAddReactionAction({
    Key key,
    @required this.post,
    this.size = 24.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reactions = post.reactions.where((e) => !e.isLike).toList();
    return SizedBox(
      height: size,
      child: Row(
        children: <Widget>[
          Container(
            width: size,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(MooncakeIcons.reaction, size: size),
              onPressed: () => _onTap(context),
            ),
          ),
          if (reactions.length > 0)
            _reactionsCount(context, reactions)
        ],
      ),
    );
  }

  Widget _reactionsCount(BuildContext context, List<Reaction> reactions) {
    return Row(
      children: [
        SizedBox(width: size / 4),
        Text(
          NumberFormat.compact().format(reactions.length),
          style: Theme.of(context).accentTextTheme.bodyText2,
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
