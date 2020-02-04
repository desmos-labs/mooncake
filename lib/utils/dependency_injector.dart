import 'package:dependencies/dependencies.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class UtilsModule implements Module {
  @override
  void configure(Binder binder) {
    binder..bindSingleton(FirebaseAnalytics());
  }
}
