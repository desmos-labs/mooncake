import 'dart:io';

/// Represents a remote source for medias.
abstract class RemoteMediasSource {
  /// Allows to upload the given [File] to the remote server, returning
  /// the remote reference to it.
  Future<String> uploadMedia(File file);
}
