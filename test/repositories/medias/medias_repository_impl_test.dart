import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/repositories/medias/medias_repository_impl.dart';
import 'package:mooncake/repositories/repositories.dart';

class RemoteMediasSourceMock extends Mock implements RemoteMediasSource {}

void main() {
  RemoteMediasSourceMock remoteMediasSource;
  MediasRepositoryImpl repository;

  setUp(() {
    remoteMediasSource = RemoteMediasSourceMock();
    repository = MediasRepositoryImpl(remoteMediasSource: remoteMediasSource);
  });

  test('uploadMedia calls proper method', () async {
    final response = 'response';
    when(remoteMediasSource.uploadMedia(any))
        .thenAnswer((_) => Future.value(response));

    final file = File('/home/user/image.png');
    final result = await repository.uploadMedia(file);
    expect(result, equals(response));

    verify(remoteMediasSource.uploadMedia(file));
  });
}
