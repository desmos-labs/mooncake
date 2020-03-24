import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return SizedBox(
      height: size,
      width: size,
      child: IconButton(
        padding: EdgeInsets.all(0.0),
        iconSize: size,
        icon: Icon(MooncakeIcons.reaction),
        onPressed: () {
          showEmojiPicker(
            context: context,
            onEmojiSelected: (emoji, _) => _onEmojiSelected(context, emoji),
          );
        },
      ),
    );
  }

  void _onEmojiSelected(BuildContext context, Emoji emoji) {
    final code = getEmojiCode(emoji.emoji);
    BlocProvider.of<PostsListBloc>(context)
        .add(AddOrRemovePostReaction(post, code));
    BlocProvider.of<NavigatorBloc>(context).add(GoBack());
  }
}
