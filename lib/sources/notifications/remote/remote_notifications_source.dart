import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:rxdart/rxdart.dart';

import 'notifications_converter.dart';

/// Implementation of [RemoteNotificationsSource].
class RemoteNotificationsSourceImpl extends RemoteNotificationsSource {
  final LocalUserSource _localUserSource;

  final _fcm = FirebaseMessaging();
  final _notificationConverter = NotificationConverter();

  // Represents the last FCM topic of an address to which we have subscribed.
  String _lastAddressSubscribedTopic;

  final _backgroundNotificationStream = BehaviorSubject<FcmMessage>();
  final _foregroundNotificationStream = BehaviorSubject<FcmMessage>();

  RemoteNotificationsSourceImpl({
    @required LocalUserSource localUserSource,
  })  : assert(localUserSource != null),
        _localUserSource = localUserSource {
    if (Platform.isIOS) {
      _fcm.onIosSettingsRegistered.listen((data) {
        print('iOS settings registered');
      });
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    // Initialize FCM
    _configureFcm();
    _subscribeToAddressTopic();
  }

  /// If the user has logged in, subscribes the FCM instance to the topic
  /// that has the value of the user address so that notification directed
  /// to him will be received in the future.
  void _subscribeToAddressTopic() {
    _localUserSource.activeAccountStream.listen((MooncakeAccount account) {
      if (_lastAddressSubscribedTopic != null) {
        _fcm.unsubscribeFromTopic(_lastAddressSubscribedTopic);
      }

      final address = account?.cosmosAccount?.address ?? '';
      if (address.isNotEmpty) {
        print('Subscribing to FCM topic: $address');
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
        .map(_notificationConverter.convert)
        .where((event) => event != null);
  }

  @override
  Stream<NotificationData> get backgroundStream {
    return _backgroundNotificationStream.stream
        .map(_notificationConverter.convert)
        .where((element) => element != null);
  }
}
