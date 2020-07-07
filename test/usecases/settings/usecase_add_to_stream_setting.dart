import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'common.dart';

void main() {
  SettingsRepository repository;
  AddToStreamSettingUseCase addToStreamSettingUseCase;
  setUp(() {
    repository = SettingsRepositoryMock();
    addToStreamSettingUseCase =
        AddToStreamSettingUseCase(settingsRepository: repository);
  });

  test('correctly adds to stream', () async {
    final controller = StreamController();
    final event = 'event 1';
    when(repository.add(any)).thenAnswer((Invocation invocation) {
      return controller.add(event);
    });

    final stream = controller.stream;
    expect(
        stream,
        emitsInOrder([
          event,
        ]));

    addToStreamSettingUseCase.add(event: event);
    await controller.close();
    verify(repository.add(event)).called(1);
  });
}
