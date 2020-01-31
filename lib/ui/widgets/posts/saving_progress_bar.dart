import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the progress bar that is shown to the user when the post
/// is being saved.
class PostSavingProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            height: 16,
            width: 16,
            child: const LoadingIndicator(),
          ),
          const SizedBox(width: 16),
          Text(PostsLocalizations.of(context).savingPost)
        ],
      ),
    );
  }
}
