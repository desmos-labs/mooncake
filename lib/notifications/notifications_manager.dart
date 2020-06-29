import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/notifications/notifications.dart';
import 'package:mooncake/repositories/repositories.dart';

/// Utility class which contains all the logic to properly handle notifications.
class NotificationsManager {
  final NotificationTapHandler _notificationsHandler;
  final RemoteNotificationsSource _notificationsSource;

  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  StreamSubscription _foregroundSub;
  StreamSubscription _backgroundSub;

  NotificationsManager({
    @required NotificationTapHandler notificationsHandler,
    @required RemoteNotificationsSource remoteNotificationsSource,
  })  : assert(notificationsHandler != null),
        _notificationsHandler = notificationsHandler,
        assert(remoteNotificationsSource != null),
        _notificationsSource = remoteNotificationsSource;

  factory NotificationsManager.create() {
    return NotificationsManager(
      notificationsHandler: Injector.get(),
      remoteNotificationsSource: Injector.get(),
    );
  }

  /// Initializes the manager subscribing to the proper streams as well
  /// as setting up necessary plugins.
  void init() {
    // Initialize the local notifications
    final initializationSettingsAndroid = AndroidInitializationSettings(
      'ic_notification',
    );
    final initializationSettingsIOS = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
      initializationSettingsAndroid,
      initializationSettingsIOS,
    );

    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {
        final notification = NotificationData.fromJson(
          jsonDecode(payload) as Map<String, dynamic>,
        );
        _notificationsHandler.handleMessage(notification);
      },
    );

    // Listen for foreground notifications
    _foregroundSub = _notificationsSource.foregroundStream.listen((message) {
      _showLocalNotification(message);
    });
    _backgroundSub = _notificationsSource.backgroundStream.listen((message) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _notificationsHandler.handleMessage(message);
      });
    });
  }

  /// Disposes the subscriptions used inside the manager.
  void dispose() {
    _foregroundSub.cancel();
    _backgroundSub.cancel();
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

    await _flutterLocalNotificationsPlugin.show(
      Random.secure().nextInt(1024),
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: jsonEncode(notification.asJson()),
    );
  }
}
