import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/main.reflectable.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeReflectable();

  // Setup the logging
  if (Foundation.kReleaseMode) {
    Foundation.debugPrint = (String message, {int wrapWidth}) {};
  }

  // Setup the dependency injection
  final path = await getApplicationDocumentsDirectory();
  await path.create(recursive: true);
  final factory = createDatabaseFactoryIo(rootPath: path.path);
  Injector.init(
    accountDatabase: await factory.openDatabase("account.db"),
    postsDatabase: await factory.openDatabase("posts.db"),
  );

  // Setup the Bloc delegate to observe transitions
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
  // ignore: missing_return
  runZoned<Future<void>>(() {
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
        create: (_) => NavigatorBloc.create(),
      ),
      BlocProvider<AccountBloc>(
        create: (context) => AccountBloc.create(context)..add(CheckStatus()),
      ),
      BlocProvider<RecoverAccountBloc>(
        create: (context) => RecoverAccountBloc.create(context),
      ),
    ],
    child: PostsApp(),
  ));
}
