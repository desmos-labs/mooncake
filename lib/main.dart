import 'package:alan/alan.dart';
import 'package:bloc/bloc.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dependency_injection/dependency_injection.dart';
import 'sources/sources.dart';

void main() async {
  // Setup the dependency injection
  Injector.init();

  // Setup the BLoC delegate to observe transitions
  BlocSupervisor.delegate = SimpleBlocDelegate();

  // Register custom messages
  Codec.registerMsgType("desmos/MsgCreatePost", MsgCreatePost);
  Codec.registerMsgType("desmos/MsgAddPostReaction", MsgAddPostReaction);
  Codec.registerMsgType("desmos/MsgRemovePostReaction", MsgRemovePostReaction);

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
