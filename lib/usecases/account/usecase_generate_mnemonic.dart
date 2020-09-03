import 'package:bip39/bip39.dart' as bip39;

/// Allows to easily generate a new mnemonic that can be used to
/// create a new account.
class GenerateMnemonicUseCase {
  /// Generates a new random 24-word mnemonic.
  Future<List<String>> generate() async {
    final mnemonic = bip39.generateMnemonic(strength: 256);
    return mnemonic.split(' ');
  }
}
