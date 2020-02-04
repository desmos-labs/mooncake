import 'package:dependencies/dependencies.dart' as di;
import 'package:mooncake/repositories/dependency_injection.dart';
import 'package:mooncake/sources/dependency_injection.dart';
import 'package:mooncake/usecases/dependency_injection.dart';
import 'package:mooncake/utils/dependency_injector.dart';

/// Utility class used to provide instances of different objects.
class Injector {
  /// Initializes the injector. Should be called inside the main method.
  static init() {
    final builder = di.Injector.builder()
      ..install(SourcesModule())
      ..install(RepositoriesModule())
      ..install(UseCaseModule())
      ..install(UtilsModule());
    final injector = builder.build();
    di.InjectorRegistry.instance.register(injector);
  }

  /// Returns the instance of the provided object having type [T].
  static T get<T>({String name}) {
    return di.InjectorRegistry.instance.get().get(name: name);
  }
}
