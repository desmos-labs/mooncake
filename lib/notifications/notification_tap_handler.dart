import 'package:flutter/widgets.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// Allows to handle the tap of the user to a specific notification
/// performing the correct action based on what's specified inside
/// the notification itself.
class NotificationTapHandler {
  final NavigatorBloc _navigatorBloc;

  NotificationTapHandler({
    @required NavigatorBloc navigatorBloc,
  })  : assert(navigatorBloc != null),
        _navigatorBloc = navigatorBloc;

  /// Handles the given [notification] accordingly, performing the needed
  /// operation(s) based on its type and data payload.
  void handleMessage(NotificationData notification) {
    if (notification is BasePostInteractionNotification) {
      switch (notification?.action) {
        case NotificationActions.ACTION_SHOW_POST:
          _navigatorBloc..add(NavigateToPostDetails(notification.postId));
          break;
      }
    }
  }
}
