import 'package:dependencies/dependencies.dart';
import 'package:mooncake/ui/blocs/export.dart';
import 'package:mooncake/ui/models/converters/export.dart';

/// Dependency injection module that defines how to build
/// some of the Bloc instances that might be useful somewhere else.
class BlocsModule implements Module {
  @override
  void configure(Binder binder) {
    binder..bindFactory((injector, params) => NavigatorBloc.create());
    binder..bindLazySingleton((injector, params) => PostConverter());
  }
}
