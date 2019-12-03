import 'package:bip39/bip39.dart' as bip39;
import 'package:desmosdemo/repositories/repositories.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:sacco/sacco.dart';

/// Implementation of [WalletSource] that saves the mnemonic into a safe place
/// using the [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)
/// plugin that stores it inside the secure hardware of the device.
class WalletSourceImpl extends WalletSource {
  static const _WALLET_KEY = "mnemonic";
  final _storage = new FlutterSecureStorage();
  final NetworkInfo _networkInfo;

  WalletSourceImpl({@required NetworkInfo networkInfo})
      : assert(networkInfo != null),
        _networkInfo = networkInfo;

  @override
  Future<void> saveWallet(String mnemonic) async {
    // Make sure the mnemonic is valid
    if (!bip39.validateMnemonic(mnemonic)) {
      throw Exception("Invalid mnemonic: $mnemonic");
    }

    // Save it safely
    await _storage.write(key: _WALLET_KEY, value: mnemonic);
  }

  @override
  Future<Wallet> getWallet() async {
    final mnemonic = await _storage.read(key: _WALLET_KEY);

    if (mnemonic == null) {
      // The mnemonic does not exist, no wallet can be created.
      return null;
    }

    // Derive the wallet
    return Wallet.derive(mnemonic.split(" "), _networkInfo);
  }

  @override
  Future<void> deleteWallet() async {
    await _storage.delete(key: _WALLET_KEY);
  }
}
