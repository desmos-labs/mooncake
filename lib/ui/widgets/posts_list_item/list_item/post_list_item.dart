import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

import 'action_bar/export.dart';

/// Represents a single entry inside a list of [Post] objects.
/// It is made of the following components:
/// - a [UserAvatar] object, containing the avatar of the post creator.
/// - a [PostItemHeader] object containing information such as the post
///    creator's username, his address and the creation date
/// - a [Text] containing the actual post message
/// - a [PostActionBar] containing all the actions that can be performed
///    for such post
class PostListItem extends StatelessWidget {
  final String postId;

  // Theming
  final double messageFontSize;
  final EdgeInsets margin;

  PostListItem({
    Key key,
    @required this.postId,
    this.messageFontSize = 0.0,
    this.margin = const EdgeInsets.all(16.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostListItemBloc, PostListItemState>(
      builder: (context, state) {
        if (state is PostListItemLoading) {
          return Container();
        }

        final currentState = (state as PostListItemLoaded);
        final post = currentState.post;
        return Card(
          margin: EdgeInsets.all(8),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: InkWell(
            onTap: () => _openPostDetails(context),
            onLongPress: post.status.value == PostStatusValue.ERRORED
                ? () => _showPostError(context, post)
                : null,
            child: Container(
              padding: PostsTheme.postItemPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  PostContent(post: post),
                  const SizedBox(height: PostsTheme.defaultPadding),
                  PostActionsBar(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openPostDetails(BuildContext context) {
    // ignore: close_sinks
    final navigatorBloc = BlocProvider.of<NavigatorBloc>(context);
    navigatorBloc.add(NavigateToPostDetails(context, postId));
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
                    style: Theme.of(buildContext).textTheme.headline6,
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
