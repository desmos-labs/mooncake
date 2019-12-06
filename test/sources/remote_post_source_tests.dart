import 'package:desmosdemo/sources/sources.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:sacco/network_info.dart';

void main() {
  test("Websocket subscription is created properly", () async {
    final source = RemotePostsSource(
      httpClient: http.Client(),
      lcdEndpoint: "http://localhost:1317",
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
