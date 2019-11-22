import 'package:desmosdemo/blocs/posts/posts_bloc.dart';
import 'package:desmosdemo/blocs/posts/posts_event.dart';
import 'package:desmosdemo/repositories/posts_repository.dart';
import 'package:desmosdemo/simple_bloc_delegate.dart';
import 'package:desmosdemo/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(
    BlocProvider(
      builder: (context) {
        return PostsBloc(
          postsRepository: const PostsRepository(),
        )..add(LoadPosts());
      },
      child: PostsApp(),
    ),
  );
}
