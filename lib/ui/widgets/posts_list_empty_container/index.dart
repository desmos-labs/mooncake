import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

/// Represent the screen that is shown to the user when no posts are found.
class PostsListEmptyContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: PostsKeys.postsEmptyContainer,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(child: Center()),
          Expanded(child: Image.asset('assets/images/sad.png')),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  PostsLocalizations.of(context).translate(Messages.noPostsYet),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20)
        ],
      ),
    );
  }
}
