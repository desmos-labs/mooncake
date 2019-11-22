import 'package:desmosdemo/localization.dart';
import 'package:desmosdemo/routes.dart';
import 'package:desmosdemo/screens/screens.dart';
import 'package:desmosdemo/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:desmosdemo/blocs/blocs.dart';

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
                builder: (context) => BlocProvider.of<PostsBloc>(context),
              ),
            ],
            child: HomeScreen(),
          );
        },
        PostsRoutes.addPost: (context) {
//          return AddEditScreen(
//            key: ArchSampleKeys.addTodoScreen,
//            onSave: (task, note) {
//              BlocProvider.of<TodosBloc>(context).add(
//                AddTodo(Todo(task, note: note)),
//              );
//            },
//            isEditing: false,
//          );
        },
      },
    );
  }
}
