import 'package:dependencies/dependencies.dart';
import 'package:mooncake/usecases/posts/export.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'notifications/notifications_repository_impl.dart';
import 'posts/posts_repository_impl.dart';
import 'user/user_repository_impl.dart';
import 'settings/settings_repository_impl.dart';
import 'users/users_repository_impl.dart';
import 'medias/medias_repository_impl.dart';

/// Represents the module that is used during dependency injection
/// to provide repositories instances.
class RepositoriesModule implements Module {
  @override
  void configure(Binder binder) {
    binder
      ..bindLazySingleton<MediasRepository>(
          (injector, params) => MediasRepositoryImpl(
                remoteMediasSource: injector.get(),
              ))
      ..bindLazySingleton<NotificationsRepository>(
          (injector, params) => NotificationsRepositoryImpl(
                localNotificationsSource: injector.get(),
                remoteNotificationsSource: injector.get(),
              ))
      ..bindLazySingleton<PostsRepository>(
          (injector, params) => PostsRepositoryImpl(
                localSource: injector.get(),
                remoteSource: injector.get(),
                localSettingsSource: injector.get(),
              ))
      ..bindLazySingleton<SettingsRepository>(
          (injector, params) => SettingsRepositoryImpl(
                localSettingsSource: injector.get(),
              ))
      ..bindLazySingleton<UserRepository>(
          (injector, params) => UserRepositoryImpl(
                localUserSource: injector.get(),
                remoteUserSource: injector.get(),
              ))
      ..bindLazySingleton<UsersRepository>(
          (injector, params) => UsersRepositoryImpl(
                localUsersSource: injector.get(),
              ));
  }
}
