abstract class LocalSettingsSource {
  /// Save the key and value locally.
  Future<void> save(String key, value);

  /// Returns value of the given key and null if not found.
  Future<dynamic> get(String key);

  /// Returns a stream based on the given key
  Stream watch(String key);
}
