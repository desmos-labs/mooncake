import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/entities/entities.dart';

void main() {
  final media = PostMedia(uri: 'media-url', mimeType: 'text/plain');

  group('isLocal', () {
    test('returns true with file image', () {
      final localImage = media.copyWith(uri: 'file://image.png');
      expect(localImage.isLocal, isTrue);
    });

    test('returns false with remote image', () {
      final httpImage = media.copyWith(uri: 'http://my-website.ord');
      expect(httpImage.isLocal, isFalse);

      final httpsImage = media.copyWith(uri: 'https://example.com');
      expect(httpsImage.isLocal, isFalse);
    });
  });

  group('isImage', () {
    test('returns true with valid images mime types', () {
      final pngImage = media.copyWith(mimeType: 'image/png');
      expect(pngImage.isImage, isTrue);

      final jpgeImage = media.copyWith(mimeType: 'image/jpeg');
      expect(jpgeImage.isImage, isTrue);

      final gifImage = media.copyWith(mimeType: 'image/gif');
      expect(gifImage.isImage, isTrue);
    });
  });

  test('toJson and fromJson', () {
    final json = media.toJson();
    final fromJson = PostMedia.fromJson(json);
    expect(fromJson, equals(media));
  });
}
