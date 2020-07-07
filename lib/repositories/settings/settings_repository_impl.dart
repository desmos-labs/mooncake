import 'package:flutter/cupertino.dart';
import 'package:mooncake/repositories/settings/source_settings_local.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Implementation of [SettingsRepository]
class SettingsRepositoryImpl extends SettingsRepository {
  final LocalSettingsSource _localSettingsSource;

  SettingsRepositoryImpl({
    @required LocalSettingsSource localSettingsSource,
  })  : assert(localSettingsSource != null),
        _localSettingsSource = localSettingsSource;

  @override
  Future<void> save(String key, value) async {
    return _localSettingsSource.save(key, value);
  }

  @override
  Future<dynamic> get(String key) async {
    return _localSettingsSource.get(key);
  }

  @override
  Stream watch(String key) {
    return _localSettingsSource.watch(key);
  }
}
