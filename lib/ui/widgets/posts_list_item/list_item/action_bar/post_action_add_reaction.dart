import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the item that the user should tap when wanting to add a
/// reaction to a post.
class AddReactionAction extends StatelessWidget {
  final double size;

  const AddReactionAction({Key key, this.size = 24.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: IconButton(
        padding: EdgeInsets.all(0.0),
        iconSize: size,
        icon: Icon(MooncakeIcons.addReaction),
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
                      onEmojiSelected: (emoji, _) =>
                          _onEmojiSelected(context, emoji),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _onEmojiSelected(BuildContext context, Emoji emoji) {
    // ignore: close_sinks
    final bloc = BlocProvider.of<PostListItemBloc>(context);
    bloc.add(AddOrRemovePostReaction(reaction: emoji.emoji));
    Navigator.pop(context);
  }
}
