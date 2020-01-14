import 'package:dependencies/dependencies.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/sources/sources.dart';
import 'package:http/http.dart' as http;

class SourcesModule implements Module {
  static const _lcdUrl = "http://10.0.2.2:1317";
  static const _rpcUrl = "ws://10.0.2.2:26657";
  final _networkInfo = NetworkInfo(bech32Hrp: "desmos", lcdUrl: _lcdUrl);

  @override
  void configure(Binder binder) {
    binder
      ..bindLazySingleton<WalletSource>(
        (injector, params) => WalletSourceImpl(
          networkInfo: _networkInfo,
        ),
      )
      ..bindLazySingleton<LocalPostsSource>(
        (injector, params) => LocalPostsSourceImpl(dbPath: "posts.db"),
        name: "local",
      )
      ..bindLazySingleton<RemotePostsSource>(
        (injector, params) => RemotePostsSourceImpl(
          rpcEndpoint: _rpcUrl,
          chainHelper: ChainHelper(
            lcdEndpoint: _lcdUrl,
            httpClient: http.Client(),
          ),
          walletSource: injector.get(),
        ),
        name: "remote",
      );
  }
}
