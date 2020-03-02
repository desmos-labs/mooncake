import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/localization/export.dart';

import 'notifications_list.dart';

/// Represents the main content of the notifications screen containing a
/// tab page that allows to view both all the notifications and the mentions.
class NotificationsMainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tabs = [
      Tab(text: PostsLocalizations.of(context).allNotificationsTabTitle),
      Tab(text: PostsLocalizations.of(context).mentionsNotificationsTabTitle),
    ];

    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          TabBar(tabs: tabs),
          Expanded(
            child: TabBarView(
              children: tabs.map((Tab tab) {
                return NotificationsList(
                  key: PageStorageKey<String>(tab.text),
                  filter: (notification) {
                    // Second tab must show only mentions
                    return tabs.indexOf(tab) != 0 &&
                        notification.type == NotificationDataType.mention;
                  },
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
