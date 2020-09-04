import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'common.dart';

void main() {
  SettingsRepository repository;
  GetSettingUseCase getSettingUseCase;

  setUp(() {
    repository = SettingsRepositoryMock();
    getSettingUseCase = GetSettingUseCase(settingsRepository: repository);
  });

  test('get performs the correct calls', () async {
    final value = 1;
    when(repository.get(any)).thenAnswer((_) => Future.value(value));

    final setting = 'setting';
    final result = await getSettingUseCase.get(key: setting);
    expect(result, equals(value));

    verify(repository.get(setting)).called(1);
  });
}
