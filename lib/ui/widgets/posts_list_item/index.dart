import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

import 'widgets/export.dart';

/// Represents a single entry inside a list of [Post] objects.
/// It is made of the following components:
/// - a [AccountAvatar] object, containing the avatar of the post creator.
/// - a [PostItemHeader] object containing information such as the post
///    creator's username, his address and the creation date
/// - a [Text] containing the actual post message
/// - a [PostActionBar] containing all the actions that can be performed
///    for such post
class PostListItem extends StatelessWidget {
  final Post post;
  PostListItem({
    Key key,
    @required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).cardColor;
    if (post.status.value != PostStatusValue.TX_SUCCESSFULL) {
      color = color.withOpacity(0.5);
    }

    return Container(
      margin: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(4.0),
        child: InkWell(
          onTap: () => _openPostDetails(context),
          onLongPress: () => _handleLongClick(context),
          child: Container(
            padding: EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                PostContent(post: post),
                if (post.reactions.isNotEmpty)
                  const SizedBox(height: ThemeSpaces.smallMargin),
                if (post.reactions.isNotEmpty) PostReactionsList(post: post),
                const SizedBox(height: ThemeSpaces.smallMargin),
                PostActionsBar(post: post),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openPostDetails(BuildContext context) {
    BlocProvider.of<NavigatorBloc>(context).add(NavigateToPostDetails(post.id));
  }

  void _handleLongClick(BuildContext context) {
    if (post.status.hasError) {
      showPostItemPopup(
        context: context,
        content: PostErrorPopupContent(error: post.status.data),
      );
    } else if (post.status.hasTxHash) {
      showPostItemPopup(
        context: context,
        content: PostSuccessPopupContent(txHash: post.status.data),
      );
    }
  }
}
