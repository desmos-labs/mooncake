import 'package:mockito/mockito.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to easily mock a [SettingsRepository] instance.
/// This is defined here so that it can be used by multiple tests to keep
/// the code DRY.
class SettingsRepositoryMock extends Mock implements SettingsRepository {}
