import 'package:test/test.dart';
import 'package:mooncake/entities/entities.dart';

void main() {
  group('toJson and fromJson', () {
    test('BiometricAuthentication', () {
      final auth = BiometricAuthentication();
      final json = auth.toJson();
      final fromJson = AuthenticationMethod.fromJson(json);
      expect(fromJson, equals(auth));
    });

    test('PasswordAuthentication', () {
      final auth = PasswordAuthentication(
        hashedPassword: '5f4dcc3b5aa765d61d8327deb882cf99',
      );
      final json = auth.toJson();
      final fromJson = PasswordAuthentication.fromJson(json);
      expect(fromJson, equals(auth));
    });
  });
}
