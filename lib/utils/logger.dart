import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';
import 'package:sentry/sentry.dart';

/// Represents a logger that allows to log the errors on the remote system.
class Logger {
  static const SENTRY_DSN =
      'https://408fde2ca63141eb99d67c184016a41b@sentry.io/2207077';

  static SentryClient sentry;

  static void init() async {
    final packageInfo = await PackageInfo.fromPlatform();
    sentry = SentryClient(
      dsn: SENTRY_DSN,
      environmentAttributes: Event(
        release: packageInfo.version,
      ),
    );
  }

  /// Remotely logs the given [error] and the optional [stackTrace] on the
  /// server.
  static void log(dynamic error, {dynamic stackTrace}) {
    if (kReleaseMode) {
      sentry.captureException(exception: error, stackTrace: stackTrace);
    } else {
      print(error);
    }
  }
}
