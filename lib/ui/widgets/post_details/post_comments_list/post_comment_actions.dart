import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the actions that are visualized inside each single comment item.
class PostCommentActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final iconSize = 20.0;
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        PostCommentAction(size: iconSize),
        SizedBox(width: iconSize),
        PostLikeAction(size: iconSize),
      ],
    );
  }
}
