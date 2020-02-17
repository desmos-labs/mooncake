import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Utility class which contains all the logic to properly handle notifications.
class NotificationsManager {
  final BuildContext _context;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Represents the last FCM topic of an address to which we have subscribed.
  String _lastAddressSubscribedTopic;

  StreamSubscription _iosSubscription;
  StreamSubscription _accountSubscription;

  NotificationsManager(this._context);

  /// Initializes the manager subscribing to the proper streams as well
  /// as setting up necessary plugins.
  void init() {
    if (Platform.isIOS) {
      _iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        print("iOS settings registered");
      });
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    // Initialize FCM
    _configureFcm();
    _subscribeToAddressTopic();

    // Initialize local notifications
    _initLocalNotifications();
  }

  /// Disposes the subscriptions used inside the manager.
  void dispose() {
    _iosSubscription.cancel();
    _accountSubscription.cancel();
  }

  /// Initializes the local notifications plugin.
  void _initLocalNotifications() {
    final initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification');
    final initializationSettingsIOS = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
      initializationSettingsAndroid,
      initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {
        _handleMessage(_context, jsonDecode(payload));
      },
    );
  }

  /// If the user has logged in, subscribes the FCM instance to the topic
  /// that has the value of the user address so that notification directed
  /// to him will be received in the future.
  void _subscribeToAddressTopic() {
    final useCase = Injector.get<GetAccountUseCase>();
    _accountSubscription = useCase.stream().listen((AccountData data) {
      if (_lastAddressSubscribedTopic != null) {
        _fcm.unsubscribeFromTopic(_lastAddressSubscribedTopic);
      }

      if (data != null) {
        print("Susbcribing to FCM topic: ${data.address}");
        _fcm.subscribeToTopic(data.address);
        _lastAddressSubscribedTopic = data.address;
      }
    });
  }

  /// Allows to properly configure FCM.
  void _configureFcm() {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("Notification onMessage: $message");
        _showLocalNotification(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("Notification onLaunch: $message");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleMessage(_context, message);
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("Notification onResume: $message");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleMessage(_context, message);
        });
      },
    );
  }

  /// Allows to properly show a local notification containing
  /// the given [message] as the payload.
  void _showLocalNotification(Map<String, dynamic> message) async {
    final fcmMessage = FcmMessage.fromJson(message);

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
      payload: jsonEncode(message),
    );
  }

  /// Handles the given [message] accordingly, performing the needed
  /// operation(s) based on its type and data payload.
  void _handleMessage(BuildContext context, Map<String, dynamic> message) {
    final fcmMessage = FcmMessage.fromJson(message);
    final data = FcmOpenPostData.fromJson(fcmMessage.data ?? {});
    switch (data?.action) {
      case FcmOpenPostData.ACTION_SHOW_POST:
        BlocProvider.of<NavigatorBloc>(context)
          ..add(NavigateToPostDetails(context, data.postId));
        break;
    }
  }
}
