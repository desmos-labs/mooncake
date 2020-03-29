import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the screen that is shown to the user while the post is loading.
class PostDetailsLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          LoadingIndicator(),
          SizedBox(height: 16),
          Text(PostsLocalizations.of(context).loadingPost),
        ],
      ),
    );
  }
}
