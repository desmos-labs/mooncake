import 'package:dependencies/dependencies.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/sources/sources.dart';

class SourcesModule implements Module {
//  static const _lcdUrl = "http://lcd.morpheus.desmos.network:1317";
//  static const _rpcUrl = "http://rpc.morpheus.desmos.network:26657";
  // TODO: Change this
  static const _lcdUrl = "http://10.0.2.2:1317";
  static const _rpcUrl = "http://10.0.2.2:26657";

  final _networkInfo = NetworkInfo(bech32Hrp: "desmos", lcdUrl: _lcdUrl);

  @override
  void configure(Binder binder) {
    binder
      // Utilities
      ..bindSingleton(ChainHelper(
        lcdEndpoint: _lcdUrl,
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
        ),
        name: "local",
      )
      ..bindLazySingleton<RemotePostsSource>(
        (injector, params) => RemotePostsSourceImpl(
          rpcEndpoint: _rpcUrl,
          chainHelper: injector.get(),
          userSource: injector.get(),
          eventsConverter: ChainEventsConverter(),
          msgConverter: MsgConverter(),
        ),
        name: "remote",
      );
  }
}
