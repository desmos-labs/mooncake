import 'package:flutter/foundation.dart';
import 'package:sentry/sentry.dart';

/// Represents a logger that allows to log the errors on the remote system.
class Logger {
  static const SENTRY_DSN =
      "https://408fde2ca63141eb99d67c184016a41b@sentry.io/2207077";

  static SentryClient sentry = new SentryClient(dsn: SENTRY_DSN);

  /// Remotely logs the given [error] and the optional [stackTrace] on the
  /// server.
  static log(dynamic error, {dynamic stackTrace}) {
    if (kDebugMode) {
      print(error);
      return;
    }

    sentry.captureException(
      exception: error,
      stackTrace: stackTrace,
    );
  }
}
