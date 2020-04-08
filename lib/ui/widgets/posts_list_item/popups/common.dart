import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

/// Allows to show a popup having the given [content].
void showPostItemPopup({
  @required BuildContext context,
  @required Widget content,
}) {
  showDialog(
    context: context,
    builder: (buildContext) {
      return Dialog(
        key: PostsKeys.postItemPopup,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          child: content,
        ),
      );
    },
  );
}
