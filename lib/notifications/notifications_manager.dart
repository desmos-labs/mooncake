import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/ui/ui.dart';

/// Utility class which contains all the logic to properly handle notifications.
class NotificationsManager {
  final BuildContext _context;
  final RemoteNotificationsSource _notificationsSource;

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  StreamSubscription _foregroundSub;
  StreamSubscription _backgroundSub;

  NotificationsManager({
    @required BuildContext context,
    @required RemoteNotificationsSource remoteNotificationsSource,
  })  : assert(context != null),
        _context = context,
        assert(remoteNotificationsSource != null),
        _notificationsSource = remoteNotificationsSource;

  /// Allows to easily create a new [NotificationManager] from the
  /// provided [context].
  factory NotificationsManager.create(BuildContext context) {
    return NotificationsManager(
      context: context,
      remoteNotificationsSource: Injector.get(),
    );
  }

  /// Initializes the manager subscribing to the proper streams as well
  /// as setting up necessary plugins.
  void init() {
    _foregroundSub = _notificationsSource.foregroundStream.listen((message) {
      _showLocalNotification(message);
    });
    _backgroundSub = _notificationsSource.backgroundStream.listen((message) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleMessage(_context, message);
      });
    });
  }

  /// Disposes the subscriptions used inside the manager.
  void dispose() {
    _foregroundSub.cancel();
    _backgroundSub.cancel();
  }

  /// Handles the given [message] accordingly, performing the needed
  /// operation(s) based on its type and data payload.
  void _handleMessage(BuildContext context, NotificationData notification) {
    if (notification is BasePostInteractionNotification) {
      switch (notification?.action) {
        case NotificationActions.ACTION_SHOW_POST:
          BlocProvider.of<NavigatorBloc>(context)
            ..add(NavigateToPostDetails(context, notification.postId));
          break;
      }
    }
  }

  /// Allows to properly show a local notification containing
  /// the given [fcmMessage] as the payload.
  void _showLocalNotification(NotificationData notification) async {
    if (notification.title == null || notification.body == null) {
      // Empty title or body, return
      return;
    }

    // Android 7.0+ and 8.0+ channel creation
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      Constants.NOTIFICATION_CHANNEL_POSTS.id,
      Constants.NOTIFICATION_CHANNEL_POSTS.title,
      Constants.NOTIFICATION_CHANNEL_POSTS.description,
      importance: Importance.Default,
      priority: Priority.Default,
    );

    final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics,
      iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      Random.secure().nextInt(1024),
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: jsonEncode(notification.asJson()),
    );
  }
}
