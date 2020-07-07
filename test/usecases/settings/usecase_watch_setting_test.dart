import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'common.dart';

void main() {
  SettingsRepository repository;
  WatchSettingUseCase watchSettingUseCase;

  setUp(() {
    repository = SettingsRepositoryMock();
    watchSettingUseCase = WatchSettingUseCase(settingsRepository: repository);
  });

  test('watch correctly returns a stream', () async {
    final controller = StreamController();
    when(repository.watch(any)).thenAnswer((_) => controller.stream);
    final keys = ["key"];
    await watchSettingUseCase.watch(keys: keys);
    verify(repository.watch(keys)).called(1);
  });
}
