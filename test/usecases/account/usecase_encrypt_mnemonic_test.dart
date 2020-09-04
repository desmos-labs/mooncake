import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/usecases/usecases.dart';

void main() {
  final encryptMnemonicUseCase = EncryptMnemonicUseCase();

  test('encryption never returns the same value twice', () async {
    final password = 'password';
    final mnemonic = [
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
    ];

    final encrypted = [];
    for (var i = 0; i < 100; i++) {
      encrypted.add(await encryptMnemonicUseCase.encrypt(mnemonic, password));
    }
    expect(encrypted, isNotEmpty);

    // Remove duplicates and check length
    final encryptedSet = encrypted.toSet();
    expect(encrypted.length, equals(encryptedSet.length));
  });
}
