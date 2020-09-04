import 'package:flutter/foundation.dart';

/// Measures the execution time of the given [function] returning its result.
/// If prints the time on the console, using the optional [name] to identify the
/// operation.
Future<T> measureExecTime<T>(
  Future<T> Function() function, {
  String name = '',
}) async {
  if (kReleaseMode) {
    // DO nothing in release mode
    return function();
  }

  final stopWatch = Stopwatch()..start();
  final result = await function();
  print('$name execution time: ${stopWatch.elapsedMilliseconds}');
  return result;
}
