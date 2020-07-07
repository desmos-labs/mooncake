import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalSettingsSourceImpl implements LocalSettingsSource {
  final Future<SharedPreferences> _sharedPrefs;

  LocalSettingsSourceImpl({
    @required Future<SharedPreferences> sharedPreferences,
  })  : assert(sharedPreferences != null),
        _sharedPrefs = sharedPreferences;

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
