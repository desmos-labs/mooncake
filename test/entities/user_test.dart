import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/entities/entities.dart';

void main() {
  group('fromJson', () {
    test('username and avatar are optional', () async {
      final file = File("test_resources/user/user.json");
      final contents = file.readAsStringSync();

      final user = User.fromJson(jsonDecode(contents));
      expect(user.address, "desmos10u276x6j0sltj4jzwnk892swcues3wehsv8dk3");
      expect(user.avatarUrl, isNull);
      expect(user.username, isNull);
    });
  });

  test('hasUsername', () {
    expect(
      User(address: "address", username: null).hasUsername,
      isFalse,
      reason: "null username should returns false",
    );

    expect(
      User(address: "address", username: "").hasUsername,
      isFalse,
      reason: "empty username should return false",
    );

    expect(
      User(address: "address", username: "username").hasUsername,
      isTrue,
      reason: "non-empty username should return true",
    );
  });

  test('hasAvatater', () {
    expect(
      User(address: "address", avatarUrl: null).hasAvatar,
      isFalse,
      reason: "null avatar url should returns false",
    );

    expect(
      User(address: "address", avatarUrl: "").hasAvatar,
      isFalse,
      reason: "empty avatar url should return false",
    );

    expect(
      User(address: "address", avatarUrl: "avatar").hasAvatar,
      isTrue,
      reason: "non-empty avatar url should return true",
    );
  });
}
