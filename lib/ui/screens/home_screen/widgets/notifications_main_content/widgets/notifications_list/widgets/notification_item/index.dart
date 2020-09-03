import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents a single notification item inside the list of notifications.
class NotificationItem extends StatelessWidget {
  final BasePostInteractionNotification notification;

  const NotificationItem({
    Key key,
    @required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;

    final notificationsText = {
      NotificationTypes.COMMENT: PostsLocalizations.of(context)
          .translate(Messages.notificationHasCommentedText),
      NotificationTypes.LIKE: PostsLocalizations.of(context)
          .translate(Messages.notificationLikedYourPost),
      NotificationTypes.REACTION: PostsLocalizations.of(context)
          .translate(Messages.notificationAddedReaction),
      NotificationTypes.MENTION: PostsLocalizations.of(context)
          .translate(Messages.notificationMentionedYou),
      NotificationTypes.TAG: PostsLocalizations.of(context)
          .translate(Messages.notificationTaggedYou),
    };

    final notificationText = notificationsText[notification.type];
    String data;
    if (notification is PostCommentNotification) {
      data = (notification as PostCommentNotification).comment;
    } else if (notification is PostReactionNotification) {
      data = (notificationText as PostReactionNotification).reaction;
    } else if (notification is PostMentionNotification) {
      data = (notification as PostMentionNotification).text;
    }

    return BlocBuilder<AccountBloc, AccountState>(
      builder: (BuildContext context, AccountState state) {
        final currentState = (state) as LoggedIn;

        return Container(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              AccountAvatar(size: 50, user: notification.user),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: notification.user.screenName,
                            style: textStyle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' $notificationText ',
                            style: textStyle,
                          ),
                          if (data != null)
                            _buildDataTextSpan(
                              username: currentState.user.screenName,
                              data: data,
                              textStyle: textStyle,
                            ),
                        ],
                      ),
                    ),
                    Text(
                      DateFormat('dd MMM yyyy').format(notification.date),
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  TextSpan _buildDataTextSpan({
    @required String username,
    @required String data,
    @required TextStyle textStyle,
  }) {
    if (!data.contains(username)) {
      // If the user is not mentioned, return a single text span
      return TextSpan(text: data, style: textStyle);
    }

    final userTag = '@$username';
    final before = data.substring(0, data.indexOf(userTag));
    final after = data.substring(data.indexOf(userTag) + userTag.length);

    return TextSpan(children: [
      if (before.isNotEmpty)
        TextSpan(
          text: before,
          style: textStyle,
        ),
      TextSpan(
        text: userTag,
        style: textStyle.copyWith(color: Colors.blueAccent),
      ),
      if (after.isNotEmpty)
        TextSpan(
          text: after,
          style: textStyle,
        ),
    ]);
  }
}
