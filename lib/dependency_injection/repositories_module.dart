import 'package:dependencies/dependencies.dart';
import 'package:desmosdemo/repositories/repositories.dart';

/// Represents the module that is used during dependency injection
/// to provide repositories instances.
class RepositoriesModule implements Module {
  @override
  void configure(Binder binder) {
    binder
      ..bindSingleton(UserRepository())
      ..bindLazySingleton((injector, params) => PostsRepository(
            userRepository: injector.get(),
            localSource: injector.get(),
          ));
  }
}
