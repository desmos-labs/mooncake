import 'package:dwitter/dependency_injection/dependency_injection.dart';
import 'package:dwitter/ui/screens/splash/splash_screen.dart';
import 'package:dwitter/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          ),
        ),
        BlocProvider<GenerateMnemonicBloc>(
          create: (context) => GenerateMnemonicBloc(
            navigatorBloc: BlocProvider.of(context),
            generateMnemonicUseCase: Injector.get(),
          ),
        ),
        BlocProvider<PostsBloc>(
          create: (context) => PostsBloc.create(syncPeriod: 20),
        )
      ],
      child: MaterialApp(
        navigatorKey: PostsKeys.navigatorKey,
        title: PostsLocalizations().appTitle,
        theme: PostsTheme.theme,
        localizationsDelegates: [
          FlutterBlocLocalizationsDelegate(),
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
