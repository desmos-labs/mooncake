import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/widgets/posts/list/post_reactions_bar.dart';

import 'post_item_header.dart';

/// Represents a single entry inside a list of [Post] objects.
/// It is made of the following components:
/// - a [UserAvatar] object, containing the avatar of the post creator.
/// - a [PostItemHeader] object containing information such as the post
///    creator's username, his address and the creation date
/// - a [Text] containing the actual post message
/// - a [PostActionBar] containing all the actions that can be performed
///    for such post
class PostItem extends StatelessWidget {
  final GestureTapCallback onTap;
  final String postId;

  // Theming
  final double messageFontSize;
  final EdgeInsets margin;

  PostItem({
    Key key,
    @required this.onTap,
    @required this.postId,
    this.messageFontSize = 0.0,
    this.margin = const EdgeInsets.all(16.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsBloc, PostsState>(
      builder: (context, state) {
        // Make sure we loaded the posts properly
        assert(state is PostsLoaded);

        final post = (state as PostsLoaded).posts.firstBy(id: postId);
        if (post == null) {
          return Container();
        }

        final theme = Theme.of(context);
        double fontSize = theme.textTheme.body1.fontSize;
        if (this.messageFontSize > 0.0) {
          fontSize = this.messageFontSize;
        }

        final messageTheme = theme.textTheme.body1.copyWith(fontSize: fontSize);
        final mdStyle =
            MarkdownStyleSheet.fromTheme(theme).copyWith(p: messageTheme);

        return Card(
          margin: this.margin,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: onTap,
            onLongPress: post.status.value == PostStatusValue.ERRORED
                ? () => _showPostError(context, post)
                : null,
            child: Container(
              padding: PostsTheme.postItemPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      UserAvatar(
                        key: PostsKeys.postItemOwnerAvatar(postId),
                        user: post.owner,
                      ),
                    const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            MarkdownBody(
                              data: post.message,
                              key: PostsKeys.postItemMessage(post.id),
                              styleSheet: mdStyle,
                            ),
                          const SizedBox(height: 4),
                            PostItemHeader(
                              key: PostsKeys.postItemOwner(post.id),
                              post: post,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                  PostActionsBar(
                    key: PostsKeys.postActionsBar(post.id),
                    postId: postId,
                  ),
                const SizedBox(height: 16),
                  PostReactionsBar(
                    key: PostsKeys.postsReactionBar(post.id),
                    postId: post.id,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPostError(BuildContext context, Post post) {
    showDialog(
        context: context,
        builder: (buildContext) {
          return Dialog(
            key: PostsKeys.syncErrorDialog,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    PostsLocalizations.of(buildContext).syncErrorTitle,
                    style: Theme.of(buildContext).textTheme.title,
                  ),
                const SizedBox(height: 16),
                  Text(PostsLocalizations.of(buildContext).syncErrorDesc),
                const SizedBox(height: 16),
                  Text(post.status.error),
                const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        child: Text("Copy error"),
                        onPressed: () => _copyError(context, post),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void _copyError(BuildContext context, Post post) {
    Clipboard.setData(ClipboardData(text: post.status.error)).then((_) {
      final snackBar = SnackBar(
        content: Text(PostsLocalizations.of(context).syncErrorCopied),
      );
      Navigator.pop(context);
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }
}
