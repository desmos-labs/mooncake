import 'dart:async';

/// Represents the repository that must be used when dealing the settings
/// that the user can change.
abstract class SettingsRepository {
  /// Saves the given [value] associating it to the specified [key].
  Future<void> save(String key, dynamic value);

  /// Reads the value associated to the given [key].
  /// If not value can be read, returns `null` instead.
  Future<dynamic> get(String key);

  StreamController<dynamic> get watch;
}
