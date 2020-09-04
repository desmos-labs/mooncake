import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'widgets/export.dart';

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
            .where((n) => filter != null ? filter.call(n) : true)
            .toList();

        if (notifications.isEmpty) {
          // No notifications to show
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(height: 50),
                Image(
                  image: AssetImage('assets/images/airplane.png'),
                  width: MediaQuery.of(context).size.width * 0.33,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace stackTrace) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.33,
                    );
                  },
                ),
                SizedBox(height: 10),
                Text(
                  PostsLocalizations.of(context)
                      .translate(Messages.noNotifications),
                  style: Theme.of(context).accentTextTheme.bodyText2,
                )
              ],
            ),
          );
        }

        return ListView.separated(
          itemCount: notifications.length,
          separatorBuilder: (BuildContext context, int index) {
            return Container(height: 0.5, color: Colors.grey);
          },
          itemBuilder: (BuildContext context, int index) {
            return NotificationItem(notification: notifications[index]);
          },
        );
      },
    );
  }
}
