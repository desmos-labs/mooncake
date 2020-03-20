import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

import 'action_bar/export.dart';
import 'reactions/post_reactions_list.dart';
import 'popups/export.dart';

/// Represents a single entry inside a list of [Post] objects.
/// It is made of the following components:
/// - a [UserAvatar] object, containing the avatar of the post creator.
/// - a [PostItemHeader] object containing information such as the post
///    creator's username, his address and the creation date
/// - a [Text] containing the actual post message
/// - a [PostActionBar] containing all the actions that can be performed
///    for such post
class PostListItem extends StatelessWidget {
  final Post post;

  // Theming
  final double messageFontSize;
  final EdgeInsets margin;

  PostListItem({
    Key key,
    @required this.post,
    this.messageFontSize = 0.0,
    this.margin = const EdgeInsets.all(16.0),
  }) : super(key: key);

  Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).cardColor;
    if (post.status.value != PostStatusValue.TX_SUCCESSFULL) {
      color = color.withOpacity(0.5);
    }

    if (post.status.value == PostStatusValue.ERRORED) {
      color = Theme.of(context).errorColor.withOpacity(0.75);
    }

    return Card(
      color: color,
      margin: EdgeInsets.all(8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: InkWell(
        onTap: () => _openPostDetails(context),
        onLongPress: _handleLongClick(context),
        child: Container(
          padding: PostsTheme.postItemPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              PostContent(post: post),
              const SizedBox(height: PostsTheme.defaultPadding),
              PostActionsBar(),
              const SizedBox(height: PostsTheme.defaultPadding),
              PostReactionsList(),
            ],
          ),
        ),
      ),
    );
  }

  void _openPostDetails(BuildContext context) {
    // ignore: close_sinks
    final navigatorBloc = BlocProvider.of<NavigatorBloc>(context);
    navigatorBloc.add(NavigateToPostDetails(context, post.id));
  }

  Function _handleLongClick(BuildContext context) {
    if (post.status.hasError) {
      return () => showPostItemPopup(
        context: context,
        content: PostErrorPopupContent(error: post.status.data),
      );
    } else if (post.status.hasTxHash) {
      return () => showPostItemPopup(
        context: context,
        content: PostSuccessPopupContent(txHash: post.status.data),
      );
    }
    return null;
  }
}
