import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

import 'notification_item.dart';

/// Represents a notifications list that can also be filtered using
/// the given [filter].
class NotificationsList extends StatelessWidget {
  final bool Function(NotificationData) filter;

  const NotificationsList({Key key, this.filter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (BuildContext context, NotificationsState state) {
        if (state is LoadingNotifications) {
          return Center(child: LoadingIndicator());
        }

        final currentState = state as NotificationsLoaded;
        final notifications = currentState.notifications
            .where((n) => filter?.call(n) ?? true)
            .toList();

        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (BuildContext context, int index) {
            return NotificationItem(notification: notifications[index]);
          },
        );
      },
    );
  }
}
