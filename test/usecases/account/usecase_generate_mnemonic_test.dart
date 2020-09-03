import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/usecases/usecases.dart';

void main() {
  final generateMnemonicUseCase = GenerateMnemonicUseCase();

  test('a mnemonic is never generated twice', () async {
    final mnemonics = [];
    for (var i = 0; i < 100; i++) {
      mnemonics.add(await generateMnemonicUseCase.generate());
    }
    expect(mnemonics, isNotEmpty);

    // Remove duplicates and check for equality
    final mnemonicSet = mnemonics.toSet();
    expect(mnemonics.length, equals(mnemonicSet.length));
  });
}
