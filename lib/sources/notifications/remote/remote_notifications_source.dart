import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:rxdart/rxdart.dart';

import 'notifications_converter.dart';

class RemoteNotificationsSourceImpl extends RemoteNotificationsSource {
  final LocalUserSource _localUserSource;

  final _fcm = FirebaseMessaging();
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final _converter = NotificationConverter();

  /// Represents the last FCM topic of an address to which we have subscribed.
  String _lastAddressSubscribedTopic;

  final _backgroundNotificationStream = BehaviorSubject<FcmMessage>();
  final _foregroundNotificationStream = BehaviorSubject<FcmMessage>();

  RemoteNotificationsSourceImpl({
    @required LocalUserSource localUserSource,
  })  : assert(localUserSource != null),
        _localUserSource = localUserSource {
    if (Platform.isIOS) {
      _fcm.onIosSettingsRegistered.listen((data) {
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

  /// Initializes the local notifications plugin.
  void _initLocalNotifications() {
    final initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification');
    final initializationSettingsIOS = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
      initializationSettingsAndroid,
      initializationSettingsIOS,
    );
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {
        final fcmMessage = FcmMessage.fromJson(jsonDecode(payload));
        _backgroundNotificationStream.add(fcmMessage);
      },
    );
  }

  /// If the user has logged in, subscribes the FCM instance to the topic
  /// that has the value of the user address so that notification directed
  /// to him will be received in the future.
  void _subscribeToAddressTopic() {
    _localUserSource.accountStream.listen((MooncakeAccount account) {
      if (_lastAddressSubscribedTopic != null) {
        _fcm.unsubscribeFromTopic(_lastAddressSubscribedTopic);
      }

      final address = account?.cosmosAccount?.address ?? "";
      if (address.isNotEmpty) {
        print("Susbcribing to FCM topic: $address");
        _fcm.subscribeToTopic(address);
        _lastAddressSubscribedTopic = address;
      }
    });
  }

  /// Allows to properly configure FCM.
  void _configureFcm() {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        final fcmMessage = FcmMessage.fromJson(message);
        _foregroundNotificationStream.add(fcmMessage);
      },
      onLaunch: (Map<String, dynamic> message) async {
        final fcmMessage = FcmMessage.fromJson(message);
        _backgroundNotificationStream.add(fcmMessage);
      },
      onResume: (Map<String, dynamic> message) async {
        final fcmMessage = FcmMessage.fromJson(message);
        _backgroundNotificationStream.add(fcmMessage);
      },
    );
  }

  @override
  Stream<NotificationData> get notificationsStream {
    return MergeStream([backgroundStream, foregroundStream]);
  }

  @override
  Stream<NotificationData> get foregroundStream {
    return _foregroundNotificationStream.stream
        .map(_converter.convertFcmMessage)
        .where((event) => event != null);
  }

  @override
  Stream<NotificationData> get backgroundStream {
    return _backgroundNotificationStream.stream
        .map(_converter.convertFcmMessage)
        .where((element) => element != null);
  }
}
