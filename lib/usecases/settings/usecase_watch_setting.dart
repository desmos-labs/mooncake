import 'package:meta/meta.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to easily watch any setting value.
class WatchSettingUseCase {
  final SettingsRepository _settingsRepository;

  WatchSettingUseCase({
    @required SettingsRepository settingsRepository,
  })  : assert(settingsRepository != null),
        _settingsRepository = settingsRepository;

  /// Returns a [Stream] that emits all the values that will be stored to the setting having the given [key].
  Stream watch({String key}) {
    return _settingsRepository.watch(key);
  }
}
