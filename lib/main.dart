import 'package:bloc/bloc.dart';
import 'package:dwitter/ui/ui.dart';
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
      BlocProvider<NavigatorBloc>(
        create: (_) => NavigatorBloc(),
      ),
      BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(
          navigatorBloc: BlocProvider.of(context),
          checkLoginUseCase: Injector.get(),
          saveWalletUseCase: Injector.get(),
        )..add(CheckStatus()),
      ),
    ],
    child: PostsApp(),
  ));
}
