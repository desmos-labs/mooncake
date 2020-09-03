import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

void main() {
  final data = MnemonicData(
    ivBase64: '3H+Sr64FhLS1VLABqZQGnw==',
    encryptedMnemonicBase64:
        'INEDpERjqL8iu8XpUbr+/1vDOFI00sQmMWHRVCm4jFlhVLINWzoQupPyZr5cgx7Ny6Q1czlxiU6+bGIu3nwyPQ==',
  );
  final decryptMnemonicUseCase = DecryptMnemonicUseCase();

  test('decryption works properly with valid password', () async {
    final password = 'password';
    final result = await decryptMnemonicUseCase.decrypt(data, password);
    expect(result, [
      'first',
      'second',
      'third',
      'fourth',
      'fifth',
      'sixth',
      'seventh',
      'eight',
      'ninth',
      'tenth',
    ]);
  });

  test('decryption fails with wrong password', () async {
    final password = 'invalid-password';
    final result = await decryptMnemonicUseCase.decrypt(data, password);
    expect(result, isNull);
  });

  test('decryption fails with invalid data', () async {
    final data = MnemonicData(encryptedMnemonicBase64: '', ivBase64: '');
    final result = await decryptMnemonicUseCase.decrypt(data, 'password');
    expect(result, isNull);
  });
}
