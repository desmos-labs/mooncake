import 'dart:io';

import 'package:dependencies/dependencies.dart';
import 'package:desmosdemo/sources/sources.dart';

class SourcesModule implements Module {
  final Future<Directory> Function() getDirectory;

  SourcesModule(this.getDirectory);

  @override
  void configure(Binder binder) {
    binder
      ..bindSingleton(FileStorage(getDirectory))
      ..bindLazySingleton((injector, params) => LocalPostsSource(
        fileStorage: injector.get(),
      ));
  }
}
