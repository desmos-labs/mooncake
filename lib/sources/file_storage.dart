import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Loads and saves a List of Todos using a text file stored on the device.
///
/// Note: This class has no direct dependencies on any Flutter dependencies.
/// Instead, the `getDirectory` method should be injected. This allows for
/// testing.
class FileStorage {
  final Future<Directory> Function() getDirectory;

  const FileStorage(this.getDirectory);

  Future<File> _getFilePath(String fileName) async {
    final dir = await getDirectory();
    if (!await dir.exists()) {
      dir.createSync();
    }
    return File('${dir.absolute.path}/$fileName');
  }

  /// Returns `true` if the file having the given [fileName] exists,
  /// `false` otherwise.
  Future<bool> exits(String fileName) async {
    final file = await _getFilePath(fileName);
    return file.exists();
  }

  /// Reads the content of the file having the given [fileName],
  /// returning it as a `String`.
  Future<String> read(String fileName) async {
    final file = await _getFilePath(fileName);
    return await file.readAsString();
  }

  /// Writes the given [value] inside the file having the given
  /// [fileName], creating it if it does not exist.
  Future<void> write(String fileName, String value) async {
    final file = await _getFilePath(fileName).then((f) => f.create());
    await file.writeAsString(value);
  }

  /// Deletes the file having the given [fileName], or throws
  /// and [Exception] is something goes wrong.
  Future<void> delete(String fileName) async {
    final file = await _getFilePath(fileName);
    await file.delete();
  }

  /// Lists all the files that are currently present inside
  /// the directory.
  Future<List<File>> listFiles() async {
    final dir = await getDirectory();
    return dir
        .list(followLinks: true)
        .where((entry) => entry is File)
        .map((entry) => entry as File)
        .toList();
  }

  /// Removes all the contents of the directory.
  Future<FileSystemEntity> clean() async {
    final file = await getDirectory();
    return file.delete(recursive: true);
  }
}
