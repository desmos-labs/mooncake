import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/notifications/notifications.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the overall application that is run
class PostsApp extends StatefulWidget {
  @override
  _PostsAppState createState() => _PostsAppState();
}

class _PostsAppState extends State<PostsApp> {
  NotificationsManager _notificationsManager;

  @override
  void initState() {
    super.initState();
    _notificationsManager = NotificationsManager.create(context);
    _notificationsManager.init();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostsListBloc>(create: (_) {
          return PostsListBloc.create(syncPeriod: 30)..add(FetchPosts());
        }),
        BlocProvider<NotificationsBloc>(create: (_) {
          return NotificationsBloc.create()..add(LoadNotifications());
        }),
      ],
      child: DynamicTheme(
        defaultBrightness: Brightness.dark,
        data: PostsTheme.themeBuilder,
        themedWidgetBuilder: (context, theme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: PostsKeys.navigatorKey,
          title: PostsLocalizations().appName,
          theme: theme,
          localizationsDelegates: [
            FlutterBlocLocalizationsDelegate(),
          ],
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: Injector.get()),
          ],
          routes: {
            PostsRoutes.home: (context) => SplashScreen(),
            PostsRoutes.recoverAccount: (context) => RecoverAccountScreen(),
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _notificationsManager.dispose();
  }
}
