import 'dart:async';

import 'package:meta/meta.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to easily save any setting value.
class WatchSettingUseCase {
  final SettingsRepository _settingsRepository;

  WatchSettingUseCase({
    @required SettingsRepository settingsRepository,
  })  : assert(settingsRepository != null),
        _settingsRepository = settingsRepository;

  StreamController<dynamic> get watch {
    return _settingsRepository.watch;
  }
}
