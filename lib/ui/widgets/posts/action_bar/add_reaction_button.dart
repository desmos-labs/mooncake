import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the item that the user should tap when wanting to add a
/// reaction to a post.
class AddReactionButton extends StatelessWidget {
  final Post post;

  const AddReactionButton({Key key, @required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      // ignore: close_sinks
                      final bloc = BlocProvider.of<PostsBloc>(buildContext);
                      bloc.add(AddOrRemovePostReaction(
                        postId: post.id,
                        reaction: emoji.emoji,
                      ));
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
}
