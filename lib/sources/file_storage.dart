import 'dart:async';
import 'dart:io';

/// Loads and saves a List of Todos using a text file stored on the device.
///
/// Note: This class has no direct dependencies on any Flutter dependencies.
/// Instead, the `getDirectory` method should be injected. This allows for
/// testing.
class FileStorage {
  Future<Directory> Function() _getDirectory;

  FileStorage(Future<Directory> Function() getDirectory) {
    assert(getDirectory != null);
    _getDirectory = () async {
      final dir = await getDirectory();
      if (!await dir.exists()) {
        dir.createSync();
      }
      return dir;
    };
  }

  Future<File> _getFilePath(String fileName) async {
    final dir = await _getDirectory();
    return File('${dir.absolute.path}/$fileName');
  }

  /// Returns `true` if the file having the given [fileName] exists,
  /// `false` otherwise.
  Future<bool> exits(String fileName) async {
    final file = await _getFilePath(fileName);
    return file.exists();
  }

  /// Reads the content of the file having the given [fileName],
  /// returning it as a `String`. If no file with the given [fileName]
  /// could be found, returns `null` instead.
  Future<String> read(String fileName) async {
    final file = await _getFilePath(fileName);
    if (await file.exists()) {
      return await file.readAsString();
    } else {
      return null;
    }
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
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Lists all the files that are currently present inside
  /// the directory.
  Future<List<File>> listFiles() async {
    final dir = await _getDirectory();
    return dir
        .list(followLinks: true)
        .where((entry) => entry is File)
        .map((entry) => entry as File)
        .toList();
  }

  /// Removes all the contents of the directory.
  Future<FileSystemEntity> clean() async {
    final file = await _getDirectory();
    return file.delete(recursive: true);
  }
}
