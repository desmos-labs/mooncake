import 'package:dependencies/dependencies.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/sources/sources.dart';

class SourcesModule implements Module {
  static const _faucetEndpoint = "https://faucet.desmos.network/airdrop";
  static const _ipfsEndpoint = "ipfs.desmos.network";

  static const _lcdUrl = kDebugMode
      ? "http://10.0.2.2:1317"
      : "http://lcd.morpheus.desmos.network:1317";

  static const _gqlEndpoint =
      kDebugMode ? "10.0.2.2:8080/v1/graphql" : "gql.desmos.network/v1/graphql";

  final _networkInfo = NetworkInfo(bech32Hrp: "desmos", lcdUrl: _lcdUrl);

  @override
  void configure(Binder binder) {
    binder
      // Utilities
      ..bindSingleton(ChainHelper(
        lcdEndpoint: _lcdUrl,
        ipfsEndpoint: _ipfsEndpoint,
      ))
      // User sources
      ..bindLazySingleton<LocalUserSource>(
          (injector, params) => LocalUserSourceImpl(
                networkInfo: _networkInfo,
                dbName: "account.db",
                secureStorage: FlutterSecureStorage(),
              ))
      ..bindLazySingleton<RemoteUserSource>(
          (injector, params) => RemoteUserSourceImpl(
                chainHelper: injector.get(),
                faucetEndpoint: _faucetEndpoint,
              ))
      // Post sources
      ..bindLazySingleton<LocalPostsSource>(
          (injector, params) => LocalPostsSourceImpl(
                dbName: "posts.db",
              ))
      ..bindLazySingleton<RemotePostsSource>(
          (injector, params) => RemotePostsSourceImpl(
                graphQlEndpoint: _gqlEndpoint,
                chainHelper: injector.get(),
                userSource: injector.get(),
                msgConverter: MsgConverter(),
              ))
      // Notifications source
      ..bindLazySingleton<RemoteNotificationsSource>(
          (injector, params) => RemoteNotificationsSourceImpl(
                localUserSource: injector.get(),
              ))
      ..bindLazySingleton<LocalNotificationsSource>(
          (injector, params) => LocalNotificationsSourceImpl(
                dbName: "user.db",
              ));
  }
}
