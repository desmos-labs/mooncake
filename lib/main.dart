import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/main.reflectable.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/utils/utils.dart';
import 'package:web_socket_channel/status.dart';

import 'entities/entities.dart';

void main() {
  initializeReflectable();

  // Setup the dependency injection
  Injector.init();

  // Setup the BLoC delegate to observe transitions
  BlocSupervisor.delegate = SimpleBlocDelegate();

  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) {
    if (Foundation.kDebugMode) {
      // In development mode, simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode, report to the application zone to report to
      // Sentry.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  // Run the app
  // ignore: missing_return
  runZoned<Future<void>>(() {
    _runApp();
  }, onError: (error, stackTrace) {
    // Whenever an error occurs, call the `_reportError` function. This sends
    // Dart errors to the dev console or Sentry depending on the environment.
    Logger.log(error, stackTrace: stackTrace);
  });

  _initTestData();
}

void _initTestData() async {
  // Test posts
  final posts = [
    Post(
      parentId: "0",
      id: "0",
      created: "2020-24-02T08:40:00.000Z",
      owner: User(
        username: "Desmos",
        accountData: AccountData(
          address: "desmos1hm422rugs829rmvrge35dea05sce86z2qf0mrc",
          accountNumber: 0,
          coins: [],
          sequence: 0,
        ),
        avatarUrl:
            "https://pbs.twimg.com/profile_images/1206578012549980162/6L485PKE_400x400.jpg",
      ),
      subspace: Constants.SUBSPACE,
      allowsComments: true,
      optionalData: {},
      status: PostStatus(value: PostStatusValue.SYNCED),
      lastEdited: null,
      message:
          "Social networking is such a massive part of our lives. From today we are giving complete power to the users",
      medias: [
        PostMedia(
          mimeType: "image/jpeg",
          url:
              "https://pbs.twimg.com/media/EMO5gOEWkAArAU1?format=jpg&name=4096x4096",
        ),
      ],
      reactions: [
        Reaction(
          owner: "desmos12v62d963xs2sqfugdtrg4a8myekvj3sf473cfv",
          value: "👍",
        ),
        Reaction(
          owner: "desmos1hm422rugs829rmvrge35dea05sce86z2qf0mrc",
          value: "😃",
        ),
        Reaction(
          owner: "desmos1hm422rugs829rmvrge35dea05sce86z2qf0mrc",
          value: "😁",
        )
      ],
      commentsIds: [],
    ),
    Post(
      parentId: "0",
      id: "1",
      created: "2020-24-02T09:00:00.000Z",
      owner: User(
          username: "Alice Jackson",
          accountData: AccountData(
            address: "desmos12v62d963xs2sqfugdtrg4a8myekvj3sf473cfv",
            accountNumber: 0,
            coins: [],
            sequence: 0,
          ),
          avatarUrl:
              "https://image.made-in-china.com/2f0j00AmtTrcdLyJoj/Wholesale-Plastic-Polarized-Custom-Women-Sunglasses.jpg"),
      subspace: Constants.SUBSPACE,
      allowsComments: true,
      optionalData: {},
      status: PostStatus(value: PostStatusValue.SYNCED),
      lastEdited: null,
      message:
          "Aliquam non sem nulla. In nulla mauris, imperdiet in ex in, egestas eleifend tellus. Curabitur facilisis mi nibh, sit amet luctus augue fermentum a.",
      medias: [
        PostMedia(
          mimeType: "image/jpeg",
          url:
              "https://www.plannthat.com/wp-content/uploads/2017/10/brahmino.png",
        ),
        PostMedia(
          mimeType: "image/jpeg",
          url:
              "https://cdn.hiconsumption.com/wp-content/uploads/2017/03/best-adventure-instagram-accounts-1087x725.jpg",
        ),
        PostMedia(
          mimeType: "image/jpeg",
          url:
              "https://kelseyinlondon.com/wp-content/uploads/2019/02/1-kelseyinlondon_kelsey_heinrichs_Paris-The-20-Best-Instagram-Photography-Locations.jpg",
        ),
        PostMedia(
          mimeType: "image/jpeg",
          url:
              "https://static2.businessinsider.com/image/546baf3069bedd6b6936ca04/the-best-instagram-accounts-to-follow.jpg",
        ),
      ],
      reactions: [
        Reaction(
          owner: "desmos12v62d963xs2sqfugdtrg4a8myekvj3sf473cfv",
          value: ":+1:",
        )
      ],
      commentsIds: [],
    ),
  ];
  final localPostsSource = Injector.get<LocalPostsSource>();
  await localPostsSource.savePosts(posts);

  // Test user
  final user = User(
    accountData: AccountData(
      address: "desmos12v62d963xs2sqfugdtrg4a8myekvj3sf473cfv",
      accountNumber: 0,
      sequence: 0,
      coins: [],
    ),
    username: "Desmos",
    avatarUrl:
        "https://pbs.twimg.com/profile_images/1206578012549980162/6L485PKE_400x400.jpg",
  );
  final localUserSource = Injector.get<LocalUserSource>();
  await localUserSource.saveUser(user);
}

void _runApp() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<NavigatorBloc>(
        create: (_) => NavigatorBloc.create(),
      ),
      BlocProvider<AccountBloc>(
        create: (context) => AccountBloc.create(context)..add(CheckStatus()),
      ),
    ],
    child: PostsApp(),
  ));
}
