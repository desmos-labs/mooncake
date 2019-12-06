import 'dart:io';

import 'package:dependencies/dependencies.dart';
import 'package:desmosdemo/repositories/repositories.dart';
import 'package:desmosdemo/sources/sources.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sacco/sacco.dart';

class SourcesModule implements Module {
  // TODO: Change this to real RPC endpoints
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
      ..bindLazySingleton<PostsSource>(
        (injector, params) => LocalPostsSource(
          postsStorage: FileStorage(() async {
            final root = await getApplicationDocumentsDirectory();
            return Directory('${root.path}/posts');
          }),
          walletSource: injector.get(),
        ),
        name: "local",
      )
      ..bindLazySingleton<PostsSource>(
        (injector, params) => RemotePostsSource(
          lcdEndpoint: _lcdUrl,
          rpcEndpoint: _rpcUrl,
          httpClient: http.Client(),
          walletSource: injector.get(),
        ),
        name: "remote",
      );
  }
}
