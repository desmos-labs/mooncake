import 'package:dependencies/dependencies.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/sources/sources.dart';
import 'package:sembast/sembast.dart';

class SourcesModule implements Module {
  static const _faucetEndpoint = "https://faucet.desmos.network/airdrop";
  static const _ipfsEndpoint = "ipfs.desmos.network";

  static const _lcdUrl = "http://lcd.morpheus.desmos.network:1317";
  static const _gqlEndpoint = "gql.morpheus.desmos.network/v1/graphql";

  final _networkInfo = NetworkInfo(bech32Hrp: "desmos", lcdUrl: _lcdUrl);

  final Database accountDatabase;
  final Database postsDatabase;
  final Database notificationsDatabase;
  SourcesModule({
    @required this.postsDatabase,
    @required this.accountDatabase,
    @required this.notificationsDatabase,
  })  : assert(postsDatabase != null),
        assert(accountDatabase != null),
        assert(notificationsDatabase != null);

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
                database: accountDatabase,
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
                database: postsDatabase,
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
                database: accountDatabase,
              ));
  }
}
