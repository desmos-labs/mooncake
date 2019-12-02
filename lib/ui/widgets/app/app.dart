import 'package:desmosdemo/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                create: (context) => TabsBloc.create(),
              ),
              BlocProvider<PostsBloc>(
                create: (context) => BlocProvider.of(context)..add(LoadPosts()),
              )
            ],
            child: HomeScreen(),
          );
        },
        PostsRoutes.addPost: (context) => CreatePostScreen(),
      },
    );
  }
}
