import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:mooncake/entities/entities.dart';

void main() {
  group('fromJson', () {
    test('username and avatar are optional', () async {
      final file = File("test_resources/user/user.json");
      final contents = file.readAsStringSync();

      final user = User.fromJson(jsonDecode(contents));
      expect(user.address, "desmos10u276x6j0sltj4jzwnk892swcues3wehsv8dk3");
      expect(user.profilePicUri, isNull);
      expect(user.moniker, isNull);
    });
  });

  test('hasAvatater', () {
    expect(
      User(address: "address", profilePicUri: null).hasAvatar,
      isFalse,
      reason: "null avatar url should returns false",
    );

    expect(
      User(address: "address", profilePicUri: "").hasAvatar,
      isFalse,
      reason: "empty avatar url should return false",
    );

    expect(
      User(address: "address", profilePicUri: "avatar").hasAvatar,
      isTrue,
      reason: "non-empty avatar url should return true",
    );
  });

  test('toJson', () {
    final user = User(
      address: "address",
      moniker: "random-username",
      profilePicUri: "http://localhost/photo",
    );
    final json = user.toJson();
    final recovered = User.fromJson(json);
    expect(recovered, user);
  });
}
