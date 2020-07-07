/// Represents the repository that must be used when dealing the settings
/// that the user can change.
abstract class SettingsRepository {
  /// Saves the given [value] associating it to the specified [key].
  Future<void> save(String key, dynamic value);

  /// Reads the value associated to the given [key].
  /// If not value can be read, returns `null` instead.
  Future<dynamic> get(String key);

  /// [Stream] that emits a value each time the given key is saved in to shared preference.
  Stream watch(String key);

  /// Adds events to the stream.
  void add(String event);
}
