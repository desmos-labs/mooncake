import 'dart:io';

import 'package:meta/meta.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Implementation of [MediasRepository].
class MediasRepositoryImpl extends MediasRepository {
  final RemoteMediasSource _remoteMediasSource;

  MediasRepositoryImpl({
    @required RemoteMediasSource remoteMediasSource,
  })  : assert(remoteMediasSource != null),
        _remoteMediasSource = remoteMediasSource;

  @override
  Future<String> uploadMedia(File file) {
    return _remoteMediasSource.uploadMedia(file);
  }
}
