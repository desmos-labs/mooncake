import 'package:bloc/bloc.dart';
import 'package:desmosdemo/blocs/blocs.dart';
import 'package:desmosdemo/simple_bloc_delegate.dart';
import 'package:desmosdemo/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dependency_injection/export.dart';

void main() async {
  // Setup the dependency injection
  Injector.init();

  // Setup the BLoC delegate to observe transitions
  BlocSupervisor.delegate = SimpleBlocDelegate();

  // Run the app
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<PostsBloc>(
        create: (context) => PostsBloc(repository: Injector.get()),
      ),
    ],
    child: PostsApp(),
  ));
}
