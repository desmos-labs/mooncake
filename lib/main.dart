import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' as Foundation;

import 'dependency_injection/dependency_injection.dart';
import 'utils/utils.dart';

void main() async {
  // Setup the dependency injection
  Injector.init();

  // Setup the BLoC delegate to observe transitions
  BlocSupervisor.delegate = SimpleBlocDelegate();

  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) {
    if (Foundation.kDebugMode) {
      // In development mode, simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode, report to the application zone to report to
      // Sentry.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  // Run the app
  runZoned<Future<void>>(() async {
    _runApp();
  }, onError: (error, stackTrace) {
    // Whenever an error occurs, call the `_reportError` function. This sends
    // Dart errors to the dev console or Sentry depending on the environment.
    Logger.log(error, stackTrace: stackTrace);
  });
}

void _runApp() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<NavigatorBloc>(
        create: (_) => NavigatorBloc(),
      ),
      BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(
          navigatorBloc: BlocProvider.of(context),
          checkLoginUseCase: Injector.get(),
        )..add(CheckStatus()),
      ),
    ],
    child: PostsApp(),
  ));
}
