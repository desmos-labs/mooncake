import 'package:mooncake/usecases/usecases.dart';
import 'package:test/test.dart';

void main() {
  final encryptMnemoncUseCase = EncryptMnemonicUseCase();
  final decryptMnemonicUseCase = DecryptMnemonicUseCase();

  group('encrypting and decrypting mnemonic', () {
    test('works properly with valid password', () async {
      final password = "password";
      final mnemonic = [
        "first" "second",
        "third",
        "fourth",
        "fifth",
        "sixth",
        "seventh",
        "eight",
        "ninth",
        "tenth",
      ];

      final encrypted = await encryptMnemoncUseCase.encrypt(mnemonic, password);
      final decrypted = await decryptMnemonicUseCase.decrypt(
        encrypted,
        password,
      );
      expect(decrypted, equals(mnemonic));
    });

    test('fails with different password', () async {
      final password = "password";
      final mnemonic = [
        "first" "second",
        "third",
        "fourth",
        "fifth",
        "sixth",
        "seventh",
        "eight",
        "ninth",
        "tenth",
      ];

      final encrypted = await encryptMnemoncUseCase.encrypt(mnemonic, password);
      final decrypted = await decryptMnemonicUseCase.decrypt(
        encrypted,
        'another',
      );
      expect(decrypted, isNull);
    });
  });
}
