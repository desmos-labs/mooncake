import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

/// Represent the screen that is shown to the user when no posts are found.
class PostsLoadingEmptyContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: PostsKeys.postsEmptyContainer,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          LoadingIndicator(),
          SizedBox(height: 16),
          Text(PostsLocalizations.of(context).translate(Messages.loadingPosts))
        ],
      ),
    );
  }
}
