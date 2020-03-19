import 'package:meta/meta.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to easily save any setting value.
class SaveSettingUseCase {
  final SettingsRepository _settingsRepository;

  SaveSettingUseCase({
    @required SettingsRepository settingsRepository,
  })  : assert(settingsRepository != null),
        _settingsRepository = settingsRepository;

  /// Saves the given [value] associating it to the specified [key].
  Future<void> save({@required String key, @required dynamic value}) {
    return _settingsRepository.save(key, value);
  }
}
