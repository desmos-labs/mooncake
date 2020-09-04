import 'dart:convert';
import 'dart:io';

import 'package:mooncake/entities/entities.dart';
import 'package:test/test.dart';

void main() {
  group('fromJson', () {
    test('username and avatar are optional', () async {
      final file = File('test_resources/user/user.json');
      final contents = file.readAsStringSync();

      final user = User.fromJson(jsonDecode(contents) as Map<String, dynamic>);
      expect(user.address, 'desmos10u276x6j0sltj4jzwnk892swcues3wehsv8dk3');
      expect(user.profilePicUri, isNull);
      expect(user.moniker, isNull);
    });
  });

  group('hasAvatater', () {
    test('returns true with valid avatar', () {
      final user = User(address: 'address', profilePicUri: 'avatar');
      expect(user.hasAvatar, isTrue);
    });

    test('returns false with empty avatar', () {
      final user = User(address: 'address', profilePicUri: null);
      expect(user.hasAvatar, isFalse);
    });

    test('returns false with empty avatar', () {
      final user = User(address: 'address', profilePicUri: '');
      expect(user.hasAvatar, isFalse);
    });
  });

  group('hasCover', () {
    test('returns true with valid cover', () {
      final user = User(address: 'address', coverPicUri: 'cover');
      expect(user.hasCover, isTrue);
    });

    test('returns false with empty cover', () {
      final user = User(address: 'address', coverPicUri: null);
      expect(user.hasCover, isFalse);
    });

    test('returns false with empty cover', () {
      final user = User(address: 'address', coverPicUri: '');
      expect(user.hasCover, isFalse);
    });
  });

  test('toJson and fromJson', () {
    final user = User(
      address: 'address',
      moniker: 'random-username',
      profilePicUri: 'http://localhost/photo',
    );
    final json = user.toJson();
    final recovered = User.fromJson(json);
    expect(recovered, user);
  });
}
