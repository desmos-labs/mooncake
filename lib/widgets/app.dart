import 'package:desmosdemo/blocs/blocs.dart';
import 'package:desmosdemo/localization.dart';
import 'package:desmosdemo/routes.dart';
import 'package:desmosdemo/screens/screens.dart';
import 'package:desmosdemo/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';
import '../screens/screens.dart';

/// Represents the overall application that is run
class PostsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: FlutterBlocLocalizations().appTitle,
      theme: PostsTheme.theme,
      localizationsDelegates: [
        FlutterBlocLocalizationsDelegate(),
      ],
      routes: {
        PostsRoutes.home: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<TabsBloc>(
                builder: (context) => TabsBloc(),
              ),
              BlocProvider<PostsBloc>(
                  builder: (context) =>
                      BlocProvider.of(context)..add(LoadPosts()))
            ],
            child: HomeScreen(),
          );
        },
        PostsRoutes.addPost: (context) => CreatePostScreen(),
      },
    );
  }
}
