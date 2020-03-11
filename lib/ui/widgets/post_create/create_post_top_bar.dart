import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the top bar that is displayed to the user inside the
/// screen used to create a new post. It contains all the actions that
/// allow the user to either cancel the post, or send it.
class CreatePostTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Row(
              children: <Widget>[
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    // TODO: Implement this
                  },
                ),
              ],
            ),
          ),
          PrimaryRoundedButton(
            text: "Post",
            onPressed: () {
              // TODO: Implement this
            },
          )
        ],
      ),
    );
  }
}
