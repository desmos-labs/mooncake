import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:pointycastle/export.dart';

/// Allows to easily encrypt the user mnemonic with a user-chosen password.
class EncryptMnemonicUseCase {
  EncryptMnemonicUseCase();

  /// Encrypts the given [mnemonic] with the provided [password].
  /// All the data necessary to later import the account are returned inside
  /// a [MnemonicData] object.
  Future<MnemonicData> encrypt(List<String> mnemonic, String password) async {
    final message = mnemonic.join(' ');

    final keyDerivator = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
      ..init(Pbkdf2Parameters(Uint8List(0), 1000, 32));
    final keyBytes = keyDerivator.process(
      Uint8List.fromList(utf8.encode(password)),
    );
    final key = base64Encode(keyBytes);

    final iv = IV.fromSecureRandom(16);
    final encrypter = Encrypter(AES(Key.fromBase64(key)));
    final encrypted = encrypter.encrypt(message, iv: iv);
    return MnemonicData(
      ivBase64: iv.base64,
      encryptedMnemonicBase64: encrypted.base64,
    );
  }
}
