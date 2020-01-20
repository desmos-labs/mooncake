import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/sources/sources.dart';

import '../../mocks/export.dart';

void main() {
  final _lcdUrl = "http://lcd.morpheus.desmos.network:1317";
  final _networkInfo = NetworkInfo(bech32Hrp: "desmos", lcdUrl: _lcdUrl);

  test('saveWallet works properly', () async {
    final storage = MockSecureStorage();
    final source = LocalUserSourceImpl(
      dbName: "users.db",
      networkInfo: _networkInfo,
      secureStorage: storage,
    );

    final mnemonic =
        "potato already proof alien rent hawk settle settle brush chase cage shell marriage drop foil garment solar join involve stock coffee toddler blur pool";
    await source.saveWallet(mnemonic);

    final savedValue = await storage.read(key: "mnemonic");
    expect(savedValue, mnemonic);
  });

  test('getWallet works properly', () async {
//    final tests = [
//      {
//        "mnemonic":
//            "potato already proof alien rent hawk settle settle brush chase cage shell marriage drop foil garment solar join involve stock coffee toddler blur pool",
//        "address": "desmos1zg0dnufdsnua3skd82r0fdv2v92kupc4tyv4fv",
//      },
//      {"mnemonic": null, "address": null}
//    ];
//
//    for (final testMap in tests) {
    final storage = MockSecureStorage();
    final source = LocalUserSourceImpl(
      dbName: "users.db",
      networkInfo: _networkInfo,
      secureStorage: storage,
    );

    final mnemonic =
        "potato already proof alien rent hawk settle settle brush chase cage shell marriage drop foil garment solar join involve stock coffee toddler blur pool";
    await storage.write(key: "mnemonic", value: mnemonic);

    final wallet = await source.getWallet();
    expect(
        wallet?.bech32Address, "desmos1zg0dnufdsnua3skd82r0fdv2v92kupc4tyv4fv");
//    }
  });
}
