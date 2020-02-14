import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Represents the overall application that is run
class PostsApp extends StatefulWidget {
  @override
  _PostsAppState createState() => _PostsAppState();
}

class _PostsAppState extends State<PostsApp> {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  StreamSubscription iosSubscription;

  @override
  void initState() {
    super.initState();

    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        print("iOS settings registered");
      });
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    // Initialize FCM
    _configureFcm();
    _subscribeToAddressTopic();
  }

  /// If the user has logged in, subscribes the FCM instance to the topic
  /// that has the value of the user address so that notification directed
  /// to him will be received in the future.
  void _subscribeToAddressTopic() {
    final usecase = Injector.get<GetAccountUseCase>();
    usecase.get().then((AccountData data) {
      if (data != null) {
        print("Susbcribing to FCM topic: ${data.address}");
        _fcm.subscribeToTopic(data.address);
      }
    });
  }

  /// Allows to properly configure FCM.
  void _configureFcm() {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        // TODO: Instead of handling like this, build a local notification
        _handleMessage(context, message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleMessage(context, message);
        });
      },
      onResume: (Map<String, dynamic> message) async {
        _handleMessage(context, message);
      },
    );
  }

  void _handleMessage(BuildContext context, Map<String, dynamic> message) {
    print("Received message: $message");
    final data = FcmMessageData.fromJson(Map.from(message["data"] ?? {}));
    switch (data.action) {
      case FcmMessageData.ACTION_SHOW_POST:
        print("Show post");
        // ignore: close_sinks
        final navigatorBloc = BlocProvider.of<NavigatorBloc>(context);
        navigatorBloc.add(NavigateToPostDetails(context, data.postId));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MnemonicInputBloc>(
          create: (_) => MnemonicInputBloc(),
        ),
        BlocProvider<RecoverAccountBloc>(
          create: (context) => RecoverAccountBloc.create(context),
        ),
        BlocProvider<GenerateMnemonicBloc>(
          create: (context) => GenerateMnemonicBloc.create(context),
        ),
        BlocProvider<PostsBloc>(
          create: (context) =>
              PostsBloc.create(syncPeriod: 30)..add(LoadPosts()),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: PostsKeys.navigatorKey,
        title: PostsLocalizations().appTitle,
        theme: PostsTheme.theme,
        localizationsDelegates: [
          FlutterBlocLocalizationsDelegate(),
        ],
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: Injector.get()),
        ],
        routes: {
          PostsRoutes.home: (context) => SplashScreen(),
          PostsRoutes.recoverAccount: (context) => RecoverAccountScreen(),
          PostsRoutes.createAccount: (context) => GenerateMnemonicScreen(),
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    iosSubscription.cancel();
  }
}
