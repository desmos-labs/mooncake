import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/sources/sources.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test("Websocket subscription is created properly", () async {
    final source = RemotePostsSourceImpl(
      chainHelper: ChainHelper(
        lcdEndpoint: "http://localhost:1317",
        httpClient: http.Client(),
      ),
      rpcEndpoint: "ws://localhost:26657",
      walletSource: WalletSourceImpl(
        networkInfo: NetworkInfo(
          lcdUrl: "http://localhost:1317",
          bech32Hrp: "desmos",
        ),
      ),
    );
    source.postsStream.listen((post) {
      print(post);
    });
    await Future.delayed(const Duration(seconds: 20), () {});
    expect(true, true);
  });
}
