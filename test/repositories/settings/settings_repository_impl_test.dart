import 'dart:async';

import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/repositories/settings/settings_repository_impl.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class MockLocalSettingsSource extends Mock implements LocalSettingsSource {}

void main() {
  final localSource = MockLocalSettingsSource();
  final repository = SettingsRepositoryImpl(localSettingsSource: localSource);

  test('watch returns a stream', () {
    final key = 'event';
    final controller = StreamController();
    when(localSource.watch(any)).thenAnswer((_) => controller.stream);
    repository.watch(key);
    verify(localSource.watch(key)).called(1);
  });
}
