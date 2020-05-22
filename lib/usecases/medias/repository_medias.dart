import 'dart:io';

/// Represents the repository to use when dealing with medias.
abstract class MediasRepository {
  /// Allows to upload the given [File] to the remote server, returning
  /// the remote reference to it.
  Future<String> uploadMedia(File file);
}
