import 'package:meta/meta.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to easily watch any setting value.
class AddToStreamSettingUseCase {
  final SettingsRepository _settingsRepository;

  AddToStreamSettingUseCase({
    @required SettingsRepository settingsRepository,
  })  : assert(settingsRepository != null),
        _settingsRepository = settingsRepository;

  /// adds events to stream
  void add({String event}) {
    return _settingsRepository.add(event);
  }
}
