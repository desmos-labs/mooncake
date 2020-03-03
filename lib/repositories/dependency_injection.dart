import 'package:dependencies/dependencies.dart';
import 'package:mooncake/usecases/posts/posts.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:mooncake/usecases/user/user.dart';

import 'posts/posts_repository_impl.dart';
import 'user/user_repository_impl.dart';
import 'notifications/notifications_repository_impl.dart';

/// Represents the module that is used during dependency injection
/// to provide repositories instances.
class RepositoriesModule implements Module {
  @override
  void configure(Binder binder) {
    binder
      ..bindLazySingleton<UserRepository>(
          (injector, params) => UserRepositoryImpl(
                localUserSource: injector.get(),
                remoteUserSource: injector.get(),
              ))
      ..bindLazySingleton<PostsRepository>(
          (injector, params) => PostsRepositoryImpl(
                localSource: injector.get(),
                remoteSource: injector.get(),
              ))
      ..bindLazySingleton<NotificationsRepository>(
          (injector, params) => NotificationsRepositoryImpl(
                localNotificationsSource: injector.get(),
                remoteNotificationsSource: injector.get(),
              ));
  }
}
