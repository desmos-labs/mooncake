import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'common.dart';

void main() {
  SettingsRepository repository;
  SaveSettingUseCase saveSettingUseCase;

  setUp(() {
    repository = SettingsRepositoryMock();
    saveSettingUseCase = SaveSettingUseCase(settingsRepository: repository);
  });

  test('save performs the correct calls', () async {
    when(repository.save(any, any)).thenAnswer((_) => Future.value(null));

    final key = 'key';
    final value = 'value';
    await saveSettingUseCase.save(key: key, value: value);

    verify(repository.save(key, value)).called(1);
  });
}
