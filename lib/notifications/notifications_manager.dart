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
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  StreamSubscription _foregroundSub;
  StreamSubscription _backgroundSub;

  NotificationsManager(this._context);

  /// Initializes the manager subscribing to the proper streams as well
  /// as setting up necessary plugins.
  void init() {
    // TODO: Inject this via constructor
    final notificationsSource = Injector.get<RemoteNotificationsSource>();
    _foregroundSub = notificationsSource.foregroundStream.listen((message) {
      _showLocalNotification(message);
    });
    _backgroundSub = notificationsSource.backgroundStream.listen((message) {
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
  void _handleMessage(BuildContext context, FcmMessage fcmMessage) {
    final data = FcmOpenPostData.fromJson(fcmMessage.data ?? {});
    switch (data?.action) {
      case FcmOpenPostData.ACTION_SHOW_POST:
        BlocProvider.of<NavigatorBloc>(context)
          ..add(NavigateToPostDetails(context, data.postId));
        break;
    }
  }

  /// Allows to properly show a local notification containing
  /// the given [fcmMessage] as the payload.
  void _showLocalNotification(FcmMessage fcmMessage) async {
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
      fcmMessage.notification.title,
      fcmMessage.notification.body,
      platformChannelSpecifics,
      payload: jsonEncode(fcmMessage.toJson()),
    );
  }
}
