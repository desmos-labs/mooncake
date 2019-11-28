import 'package:bloc/bloc.dart';
import 'package:desmosdemo/blocs/blocs.dart';
import 'package:desmosdemo/simple_bloc_delegate.dart';
import 'package:desmosdemo/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'dependency_injection/export.dart';

void main() {
  // Setup the dependency injection
  Injector.init(getApplicationDocumentsDirectory);

  // Setup the BLoC delegate to observe transitions
  BlocSupervisor.delegate = SimpleBlocDelegate();

  // Run the app
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<PostsBloc>(
        builder: (context) => PostsBloc(repository: Injector.get()),
      ),
    ],
    child: PostsApp(),
  ));
}
