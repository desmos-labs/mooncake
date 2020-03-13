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

import 'entities/entities.dart';

void main() {
  initializeReflectable();

  // Setup the dependency injection
  Injector.init();

  // Setup the Bloc delegate to observe transitions
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

  if (Foundation.kDebugMode) {
    _initTestData();
  }
}

void _initTestData() async {
  final user = await _initUser();
  _initPosts(user);
  _initNotifications();
}

void _initPosts(User user) async {
  final posts = [
    Post(
      parentId: "0",
      id: "1",
      created: "2020-24-02T08:40:00.000Z",
      owner: User(
        username: "Desmos",
        accountData: AccountData(
          address: "desmos1hm422rugs829rmvrge35dea05sce86z2qf0mrc",
          accountNumber: 0,
          coins: [],
          sequence: 0,
        ),
        avatarUrl: "https://i.pravatar.cc/300?img=1",
      ),
      subspace: Constants.SUBSPACE,
      allowsComments: true,
      optionalData: {},
      status: PostStatus(value: PostStatusValue.SYNCED),
      lastEdited: null,
      message:
          "Social networking is such a massive part of our lives. From today we are giving complete power to the users. Visit [desmos.network](https://desmos.network).",
      medias: [
        PostMedia(
          mimeType: "image/jpeg",
          url:
              "https://pbs.twimg.com/media/EMO5gOEWkAArAU1?format=jpg&name=4096x4096",
        ),
      ],
      reactions: [
        Reaction(
          user: user,
          value: "👍",
        ),
        Reaction(
          user: User.fromAddress(
            "desmos1hm422rugs829rmvrge35dea05sce86z2qf0mrc",
          ),
          value: "😃",
        ),
        Reaction(
          user: User.fromAddress(
            "desmos1hm422rugs829rmvrge35dea05sce86z2qf0mrc",
          ),
          value: "😁",
        )
      ],
      commentsIds: ["3"],
    ),
    Post(
      parentId: "0",
      id: "2",
      created: "2020-24-02T09:00:00.000Z",
      owner: User(
        username: "Alice Jackson",
        accountData: AccountData.offline(
          "desmos12v62d963xs2sqfugdtrg4a8myekvj3sf473cfv",
        ),
        avatarUrl: "https://i.pravatar.cc/300?img=2",
      ),
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
          user: User.fromAddress(
            "desmos12v62d963xs2sqfugdtrg4a8myekvj3sf473cfv",
          ),
          value: ":+1:",
        )
      ],
      commentsIds: [],
    ),
    Post(
      parentId: "1",
      id: "3",
      created: "2020-24-04T09:00:00.000Z",
      owner: User(
        username: "Alice Jackson",
        accountData: AccountData.offline(
          "desmos12v62d963xs2sqfugdtrg4a8myekvj3sf473cfv",
        ),
        avatarUrl: "https://i.pravatar.cc/300?img=3",
      ),
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
          user: User.fromAddress(
            "desmos12v62d963xs2sqfugdtrg4a8myekvj3sf473cfv",
          ),
          value: ":+1:",
        )
      ],
      commentsIds: [],
    ),
  ];

  final localPostsSource = Injector.get<LocalPostsSource>();
  posts.forEach((post) async {
    await localPostsSource.savePost(post);
  });
}

Future<User> _initUser() async {
  final user = User(
    accountData: AccountData(
      address: "desmos16f9wz7yg44pjfhxyn22kycs0qjy778ng877usl",
      accountNumber: 0,
      sequence: 0,
      coins: [
        StdCoin(
          denom: Constants.FEE_TOKEN,
          amount: "21300",
        ),
      ],
    ),
    username: "mooncake",
    avatarUrl:
        "https://pbs.twimg.com/profile_images/1206578012549980162/6L485PKE_400x400.jpg",
  );
  final localUserSource = Injector.get<LocalUserSource>();
  await localUserSource.saveUser(user);

  return user;
}

void _initNotifications() async {
  final localSource = Injector.get<LocalNotificationsSource>();
  final notifications = [
    PostCommentNotification(
      postId: "0",
      user: User(
        username: "Nick Haynes",
        avatarUrl:
            "https://specials-images.forbesimg.com/imageserve/5d70b0225b52ce0008826162/960x0.jpg?fit=scale",
        accountData: AccountData(
          sequence: 0,
          coins: [],
          accountNumber: 0,
          address: "",
        ),
      ),
      comment: "Curabitus nisl",
      date: DateTime.now(),
    ),
    PostCommentNotification(
      postId: "1",
      user: User(
        username: "Keanu Stanley",
        avatarUrl:
            "https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Outdoors-man-portrait_%28cropped%29.jpg/1200px-Outdoors-man-portrait_%28cropped%29.jpg",
        accountData: AccountData(
          sequence: 0,
          coins: [],
          accountNumber: 0,
          address: "",
        ),
      ),
      comment: "Magna ne Mattis enim lorem",
      date: DateTime.now(),
    ),
    PostCommentNotification(
      postId: "1",
      user: User(
        username: "Matthew Alvarado",
        avatarUrl:
            "https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Outdoors-man-portrait_%28cropped%29.jpg/1200px-Outdoors-man-portrait_%28cropped%29.jpg",
        accountData: AccountData(
          sequence: 0,
          coins: [],
          accountNumber: 0,
          address: "",
        ),
      ),
      comment:
          "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...",
      date: DateTime.now(),
    ),
    PostMentionNotification(
      postId: "1",
      user: User(
        username: "Carolyn",
        avatarUrl:
            "https://www.amica.it/wp-content/uploads/2019/04/ana-de-armes4-635x635.jpg",
        accountData: AccountData(
          sequence: 0,
          coins: [],
          accountNumber: 0,
          address: "",
        ),
      ),
      text: "@mooncake great!!!",
      date: DateTime.now(),
    ),
    PostMentionNotification(
      postId: "1",
      user: User(
        username: "Carolyn",
        avatarUrl:
            "https://www.amica.it/wp-content/uploads/2019/04/ana-de-armes4-635x635.jpg",
        accountData: AccountData(
          sequence: 0,
          coins: [],
          accountNumber: 0,
          address: "",
        ),
      ),
      text: "I love @mooncake",
      date: DateTime.now(),
    ),
    PostMentionNotification(
      postId: "1",
      user: User(
        username: "Carolyn",
        avatarUrl:
            "https://www.amica.it/wp-content/uploads/2019/04/ana-de-armes4-635x635.jpg",
        accountData: AccountData(
          sequence: 0,
          coins: [],
          accountNumber: 0,
          address: "",
        ),
      ),
      text: "Go @mooncake, go!",
      date: DateTime.now(),
    ),
  ];

  notifications.forEach((element) async {
    await localSource.saveNotification(element);
  });
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
      BlocProvider<RecoverAccountBloc>(
        create: (context) => RecoverAccountBloc.create(context),
      ),
    ],
    child: PostsApp(),
  ));
}
