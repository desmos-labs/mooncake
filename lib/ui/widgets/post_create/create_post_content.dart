import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

import 'create_post_top_bar.dart';

/// Contains the main content of the post creation screen.
/// Such content includes a top bar and the [TextFormField] inside which
/// the post message is inserted.
class CreatePostContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          children: <Widget>[
            CreatePostTopBar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  key: PostsKeys.postMessageField,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "What's on your mind?",
                  ),
                  autocorrect: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
