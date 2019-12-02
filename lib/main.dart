import 'package:bloc/bloc.dart';
import 'package:desmosdemo/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dependency_injection/dependency_injection.dart';

void main() async {
  // Setup the dependency injection
  Injector.init();

  // Setup the BLoC delegate to observe transitions
  BlocSupervisor.delegate = SimpleBlocDelegate();

  // Run the app
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<PostsBloc>(create: (_) => PostsBloc.create(syncPeriod: 20)),
    ],
    child: PostsApp(),
  ));
}
