import 'dart:convert';

import 'package:mooncake/usecases/usecases.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementation of [SettingsRepository]
class SettingsRepositoryImpl extends SettingsRepository {
  /// Returns the [SharedPreferences] instance used to save the user
  /// settings.
  Future<SharedPreferences> get _sharedPrefs {
    return SharedPreferences.getInstance();
  }

  @override
  Future<void> save(String key, value) async {
    final jsonValue = jsonEncode(value);
    final prefs = await _sharedPrefs;
    await prefs.setString(key, jsonValue);
  }

  @override
  Future<dynamic> get(String key) async {
    final prefs = await _sharedPrefs;
    if (!prefs.containsKey(key)) {
      return null;
    }

    final jsonValue = prefs.getString(key);
    return jsonDecode(jsonValue);
  }
}
