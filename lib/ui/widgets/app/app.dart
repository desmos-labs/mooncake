import 'package:desmosdemo/dependency_injection/dependency_injection.dart';
import 'package:desmosdemo/ui/screens/splash/splash_screen.dart';
import 'package:desmosdemo/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Represents the overall application that is run
class PostsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: PostsKeys.navigatorKey,
      title: PostsLocalizations().appTitle,
      theme: PostsTheme.theme,
      localizationsDelegates: [
        FlutterBlocLocalizationsDelegate(),
      ],
      routes: {
        PostsRoutes.home: (context) => SplashScreen(),
        PostsRoutes.addPost: (context) => CreatePostScreen(),
        PostsRoutes.recoverAccount: (context) => MultiBlocProvider(
              providers: [
                BlocProvider<MnemonicInputBloc>(
                  create: (_) => MnemonicInputBloc(),
                ),
                BlocProvider<RecoverAccountBloc>(
                  create: (context) => RecoverAccountBloc(
                    mnemonicInputBloc: BlocProvider.of(context),
                    loginBloc: BlocProvider.of(context),
                  ),
                )
              ],
              child: RecoverAccountScreen(),
            ),
        PostsRoutes.createAccount: (context) => BlocProvider(
              create: (context) => GenerateMnemonicBloc(
                navigatorBloc: BlocProvider.of(context),
                generateMnemonicUseCase: Injector.get(),
              ),
              child: GenerateMnemonicScreen(),
            ),
      },
    );
  }
}
