import 'dart:async';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Model for any event change
class SettingChangeEvent {
  final String key;
  final dynamic value;

  SettingChangeEvent({this.key, this.value});
}

/// Implementation of [LocalSettingsSource] that deals with local data.
class LocalSettingsSourceImpl implements LocalSettingsSource {
  final Future<SharedPreferences> _sharedPrefs;
  final StreamController _controller =
      StreamController<SettingChangeEvent>.broadcast();

  LocalSettingsSourceImpl({
    @required Future<SharedPreferences> sharedPreferences,
  })  : assert(sharedPreferences != null),
        _sharedPrefs = sharedPreferences;

  @override
  Future<void> save(String key, value) async {
    final jsonValue = jsonEncode(value);
    final prefs = await _sharedPrefs;
    await prefs.setString(key, jsonValue);
    _controller.add(SettingChangeEvent(
      key: key,
      value: value,
    ));
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

  @override
  Stream<dynamic> watch(String key) {
    return _controller.stream
        .where((event) => key == event.key)
        .map((event) => event.value);
  }
}
