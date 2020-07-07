import 'dart:async';

import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/repositories/settings/settings_repository_impl.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class MockLocalSettingsSource extends Mock implements LocalSettingsSource {}

void main() {
  final MockLocalSettingsSource localSource = MockLocalSettingsSource();
  final repository = SettingsRepositoryImpl(localSettingsSource: localSource);

  test('watch returns a stream', () {
    final String event = 'event';
    final StreamController controller = StreamController();
    when(localSource.watch(any)).thenAnswer((_) => controller.stream);
    repository.watch(event);
    verify(localSource.watch(event)).called(1);
  });
}
