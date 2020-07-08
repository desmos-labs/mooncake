import 'package:meta/meta.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to easily watch any setting value.
class WatchSettingUseCase {
  final SettingsRepository _settingsRepository;

  WatchSettingUseCase({
    @required SettingsRepository settingsRepository,
  })  : assert(settingsRepository != null),
        _settingsRepository = settingsRepository;

  /// Returns a stream that returns the value being saved by the given key in shared preference
  Stream watch({String key}) {
    return _settingsRepository.watch(key);
  }
}
