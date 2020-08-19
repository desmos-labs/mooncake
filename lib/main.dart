import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/main.reflectable.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
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
    BlocSupervisor.delegate = SimpleBlocDelegate();
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
      "account.db",
      version: 5,
      onVersionChanged: (db, oldVersion, newVersion) async {
        // From Cosmos v0.38 to v0.39 the serialization of the account has
        // changed and the account_number and sequence are now string.
        // We need to convert any previous int values here
        final store = StoreRef.main();
        final record = await store.record("user_data").get(db);
        if (record == null) return;

        final json = Map.from(record as Map<String, dynamic>);
        final cosmos = Map.from(json["cosmos_account"] as Map<String, dynamic>);

        final accNumber = cosmos["account_number"];
        if (accNumber is int) {
          cosmos.update("account_number", (value) => accNumber.toString());
        }

        final sequence = cosmos["sequence"];
        if (sequence is int) {
          cosmos.update("sequence", (value) => sequence.toString());
        }

        json.update("cosmos_account", (value) => cosmos);
        await store.record("user_data").update(db, json);
      },
    ),
    postsDatabase: await factory.openDatabase("posts.db"),
    notificationDatabase: await factory.openDatabase("user.db"),
    blockedUsersDatabase: await factory.openDatabase("blocked_users.db"),
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
