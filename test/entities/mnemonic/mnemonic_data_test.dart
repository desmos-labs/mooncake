import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/entities/entities.dart';

void main() {
  final data = MnemonicData(
    encryptedMnemonicBase64: 'encrypted_mnemonic_base64',
    ivBase64: 'iv_base_64',
  );

  test('toJson and fromJson', () {
    final json = data.toJson();
    final fromJson = MnemonicData.fromJson(json);
    expect(fromJson, equals(data));
  });
}
