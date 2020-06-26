import 'package:dependencies/dependencies.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_auth/local_auth.dart';

class UtilsModule implements Module {
  @override
  void configure(Binder binder) {
    binder
      ..bindSingleton(FlutterLocalNotificationsPlugin())
      ..bindSingleton(FirebaseAnalytics())
      ..bindSingleton(LocalAuthentication());
  }
}
