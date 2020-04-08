import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Allows to show a picker that permits the user to select an emoji, and
/// calls [onEmojiSelected] once an emoji has been clicked.
void showEmojiPicker({
  @required BuildContext context,
  @required OnEmojiSelected onEmojiSelected,
}) {
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
              onEmojiSelected: onEmojiSelected,
            ),
          ],
        ),
      );
    },
  );
}
