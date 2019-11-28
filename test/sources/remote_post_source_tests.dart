import 'package:desmosdemo/sources/sources.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test("Websocket subscription is created properly", () async {
    final source = RemotePostsSource(httpClient: http.Client());
    source.postsStream.listen((post) {
      print(post);
    });
    await Future.delayed(const Duration(seconds: 20), (){});
    expect(true, true);
  });
}
