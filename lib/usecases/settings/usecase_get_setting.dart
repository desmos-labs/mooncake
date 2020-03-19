import 'package:meta/meta.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to easily read any setting value based on its key.
class GetSettingUseCase {
  final SettingsRepository _settingsRepository;

  GetSettingUseCase({
    @required SettingsRepository settingsRepository,
  })  : assert(settingsRepository != null),
        _settingsRepository = settingsRepository;

  /// Reads the value associated to the given [key].
  /// If not value can be read, returns `null` instead.
  Future<dynamic> get({@required String key}) {
    return _settingsRepository.get(key);
  }
}
