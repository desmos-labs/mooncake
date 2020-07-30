import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
    _notificationsManager = NotificationsManager.create();
    _notificationsManager.init();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostsListBloc>(create: (context) {
          return PostsListBloc.create(context, syncPeriod: 30)
            ..add(FetchPosts());
        }),
        BlocProvider<NotificationsBloc>(create: (_) {
          return NotificationsBloc.create()..add(LoadNotifications());
        }),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: PostsKeys.navigatorKey,
        title: 'Mooncake',
        themeMode: ThemeMode.system,
        theme: PostsTheme.lightTheme,
        darkTheme: PostsTheme.darkTheme,
        home: SplashScreen(),
        localizationsDelegates: [
          PostsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en'), // English, no country code
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocaleLanguage in supportedLocales) {
            if (supportedLocaleLanguage.languageCode == locale.languageCode) {
              return supportedLocaleLanguage;
            }
          }
          return supportedLocales.first;
        },
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: Injector.get()),
        ],
      ),
    );
  }
}
