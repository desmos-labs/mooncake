import 'package:dependencies/dependencies.dart';
import 'package:desmosdemo/repositories/posts_repository.dart';

/// Represents the module that is used during dependency injection
/// to provide repositories instances.
class RepositoriesModule implements Module {
  @override
  void configure(Binder binder) {
    binder..bindSingleton(PostsRepository());
  }
}
