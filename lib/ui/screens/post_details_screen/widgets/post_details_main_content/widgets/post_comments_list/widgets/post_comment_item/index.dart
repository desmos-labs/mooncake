import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Represents single item entry inside the list of post comments.
class PostCommentItem extends StatelessWidget {
  static const ICON_SIZE = 20.0;

  final Post comment;
  PostCommentItem({Key key, @required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
        builder: (BuildContext context, AccountState accountState) {
      final state = accountState as LoggedIn;
      final isLiked = state.user.hasLiked(comment);

      return InkWell(
        onTap: () => _onTap(context),
        child: Container(
          padding: EdgeInsets.all(16.0),
          // child: Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     AccountAvatar(size: 40, user: comment.owner),
          //     const SizedBox(width: ThemeSpaces.largeGutter),
          //     Expanded(
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Row(
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             children: [
          //               Text(
          //                 comment.owner.screenName,
          //                 overflow: TextOverflow.ellipsis,
          //                 style:
          //                     Theme.of(context).textTheme.subtitle1.copyWith(
          //                           fontWeight: FontWeight.w500,
          //                         ),
          //               ),
          //               const SizedBox(width: ThemeSpaces.largeGutter),
          //               Text(
          //                 timeago.format(
          //                   comment.dateTime
          //                       .add(DateTime.now().timeZoneOffset),
          //                   clock: DateTime.now(),
          //                 ),
          //                 style: Theme.of(context).textTheme.caption.copyWith(
          //                     fontSize: 10,
          //                     color:
          //                         Theme.of(context).colorScheme.onSecondary),
          //               )
          //             ],
          //           ),
          //           if (comment.message?.isNotEmpty == true)
          //             PostMessage(post: comment),
          //           PostImagesPreviewer(post: comment),
          //           const SizedBox(height: ThemeSpaces.smallGutter),
          //           _commentActions(isLiked),
          //         ],
          //       ),
          //     )
          //   ],
          // )
          // wingman
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              PostItemHeader(post: comment),
              const SizedBox(height: ThemeSpaces.smallGutter),
              Row(
                children: [
                  const SizedBox(width: ThemeSpaces.largeGutter + 40),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (comment.message?.isNotEmpty == true)
                          PostMessage(post: comment),
                        if (comment.message?.isNotEmpty == true)
                          const SizedBox(height: ThemeSpaces.smallGutter),
                        PostImagesPreviewer(post: comment),
                        const SizedBox(height: ThemeSpaces.smallGutter),
                        _commentActions(isLiked),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  List<Widget> _textWidget() {
    return [
      PostMessage(post: comment),
      const SizedBox(height: ThemeSpaces.smallGutter),
    ];
  }

  Row _commentActions(bool isLiked) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        PostCommentAction(size: ICON_SIZE, post: comment),
        const SizedBox(width: ICON_SIZE),
        PostAddReactionAction(size: ICON_SIZE, post: comment),
      ],
    );
  }

  void _onTap(BuildContext context) {
    BlocProvider.of<NavigatorBloc>(context)
        .add(NavigateToPostDetails(comment.id));
  }
}
