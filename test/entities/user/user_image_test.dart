import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/entities/entities.dart';

void main() {
  group('LocalUserImage', () {
    final image = LocalUserImage(File('image'));

    test('toJson and fromJson', () {
      final json = image.toJson();
      final fromJson = AccountImage.fromJson(json);
      expect(fromJson, equals(image));
    });
  });

  group('NetworkUserImage', () {
    final image = NetworkUserImage('https://example.com/image');

    test('toJson and fromJson', () {
      final json = image.toJson();
      final fromJson = AccountImage.fromJson(json);
      expect(fromJson, equals(image));
    });
  });

  group('NoUserImage', () {
    final image = NoUserImage();

    test('toJson and fromJson', () {
      final json = image.toJson();
      final fromJson = AccountImage.fromJson(json);
      expect(fromJson, equals(image));
    });
  });
}
