import 'package:dependencies/dependencies.dart';
import 'package:mooncake/notifications/notifications.dart';

/// Dependency injection module that builds the different
/// instances for the classes related to the notifications management.
class NotificationsModule implements Module {
  @override
  void configure(Binder binder) {
    binder
      ..bindLazySingleton<NotificationTapHandler>(
          (injector, _) => NotificationTapHandler(
                navigatorBloc: injector.get(),
              ));
  }
}
