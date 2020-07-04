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

  test('watch performs the correct calls', () async {
    final controller = StreamController();

    when(repository.watch).thenAnswer((_) => controller);
    final stream = watchSettingUseCase.watch.stream;

    expect(
        stream,
        emitsInOrder([
          'one',
          'two',
        ]));

    controller.add('one');
    controller.add('two');
    await controller.close();
    verify(repository.watch).called(1);
  });
}
