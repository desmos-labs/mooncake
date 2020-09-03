import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:pointycastle/export.dart';

/// Allows to easily decrypt a given mnemonic data by using the same password
/// that was used while encrypting it.
class DecryptMnemonicUseCase {
  DecryptMnemonicUseCase();

  /// Decrypts the given [data] by using the given [password].
  /// If the password is valid, returns the mnemonic present inside [data]
  /// as a List of String.
  /// Otherwise, returns `null` if the password is not valid or the data
  /// is somehow corrupted.
  Future<List<String>> decrypt(MnemonicData data, String password) async {
    try {
      final keyDerivator = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
        ..init(Pbkdf2Parameters(Uint8List(0), 1000, 32));
      final keyBytes = keyDerivator.process(
        Uint8List.fromList(utf8.encode(password)),
      );
      final key = base64Encode(keyBytes);

      final iv = IV.fromBase64(data.ivBase64);
      final encrypter = Encrypter(AES(Key.fromBase64(key)));
      final decrypted = encrypter.decrypt(
        Encrypted.fromBase64(data.encryptedMnemonicBase64),
        iv: iv,
      );
      return decrypted.split(' ');
    } catch (e) {
      return null;
    }
  }
}
