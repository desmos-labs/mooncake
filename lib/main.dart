import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/db_migrations.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/main.reflectable.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

void main() async {
  // Init widget bindings
  WidgetsFlutterBinding.ensureInitialized();

  // Init reflectable
  initializeReflectable();

  // Init the logger
  await Logger.init();

  // Setup the dependency injection
  await _setupDependencyInjection();

  // Setup the Bloc delegate to observe transitions
  if (foundation.kDebugMode) {
    Bloc.observer = SimpleBlocObserver();
  }

  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) {
    if (foundation.kDebugMode) {
      // In development mode, simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode, report to the application zone to report to
      // Sentry.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  // Run the app
  // ignore: missing_return
  runZonedGuarded(() {
    _runApp();
  }, (error, stackTrace) {
    // Whenever an error occurs, call the `_reportError` function. This sends
    // Dart errors to the dev console or Sentry depending on the environment.
    Logger.log(error, stackTrace: stackTrace);
  });
}

/// Setup the dependency injection.
Future _setupDependencyInjection() async {
  final path = await getApplicationDocumentsDirectory();
  await path.create(recursive: true);
  final factory = createDatabaseFactoryIo(rootPath: path.path);
  Injector.init(
    accountDatabase: await factory.openDatabase(
      'account.db',
      version: 3,
      onVersionChanged: (db, oldVersion, newVersion) async {
        if (oldVersion == 1) {
          await migrateV1AccountDatabase(db);
          oldVersion = 2;
        }

        if (oldVersion == 2) {
          await migrateV2AccountDatabase(db);
        }
      },
    ),
    postsDatabase: await factory.openDatabase(
      'posts.db',
      version: 4,
      onVersionChanged: (db, oldVersion, newVersion) async {
        if (oldVersion < 4) {
          await deletePosts(db);
        }
      },
    ),
    notificationDatabase: await factory.openDatabase('notifications.db'),
    blockedUsersDatabase: await factory.openDatabase('blocked_users.db'),
  );
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
        create: (context) => RecoverAccountBloc.create(),
      ),
    ],
    child: PostsApp(),
  ));
}
