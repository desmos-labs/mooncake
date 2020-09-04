import 'package:dependencies/dependencies.dart' as di;
import 'package:meta/meta.dart';
import 'package:mooncake/notifications/dependency_injection.dart';
import 'package:mooncake/repositories/dependency_injection.dart';
import 'package:mooncake/sources/dependency_injection.dart';
import 'package:mooncake/ui/dependency_injection.dart';
import 'package:mooncake/usecases/dependency_injection.dart';
import 'package:mooncake/utils/dependency_injector.dart';
import 'package:sembast/sembast.dart';

/// Utility class used to provide instances of different objects.
class Injector {
  /// Initializes the injector. Should be called inside the main method.
  static void init({
    @required Database accountDatabase,
    @required Database postsDatabase,
    @required Database notificationDatabase,
    @required Database blockedUsersDatabase,
  }) {
    final builder = di.Injector.builder()
      ..install(SourcesModule(
        accountDatabase: accountDatabase,
        postsDatabase: postsDatabase,
        notificationsDatabase: notificationDatabase,
        blockedUsersDatabase: blockedUsersDatabase,
      ))
      ..install(RepositoriesModule())
      ..install(UseCaseModule())
      ..install(UtilsModule())
      ..install(NotificationsModule())
      ..install(BlocsModule());
    final injector = builder.build();
    di.InjectorRegistry.instance.register(injector);
  }

  /// Returns the instance of the provided object having type [T].
  static T get<T>({String name}) {
    return di.InjectorRegistry.instance.get().get(name: name);
  }
}
