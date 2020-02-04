import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/ui/screens/splash/splash_screen.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the overall application that is run
class PostsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MnemonicInputBloc>(
          create: (_) => MnemonicInputBloc(),
        ),
        BlocProvider<RecoverAccountBloc>(
          create: (context) => RecoverAccountBloc(
            mnemonicInputBloc: BlocProvider.of(context),
            loginBloc: BlocProvider.of(context),
            loginUseCase: Injector.get(),
            getAddressUseCase: Injector.get(),
          ),
        ),
        BlocProvider<GenerateMnemonicBloc>(
          create: (context) => GenerateMnemonicBloc.create(context),
        ),
        BlocProvider<PostsBloc>(
          create: (context) =>
              PostsBloc.create(syncPeriod: 20)..add(FetchPosts()),
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
}
