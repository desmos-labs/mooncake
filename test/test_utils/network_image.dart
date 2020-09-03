import 'dart:io';

import 'package:mockito/mockito.dart';

/// Runs [body] in a fresh [Zone] that provides mocked responses for [Image.network] widgets.
///
/// Behind the scenes, this creates a mocked HTTP client that responds with mocked
/// image data to all HTTP GET requests.
///
/// This is a workaround needed for widget tests that use network images. Without
/// the mocked HTTP client, any widget tests that pump a widget tree containing
/// [Image.network] widgets will crash.
///
/// By default, the mocked HTTP client will respond with [_transparentImage]. If
/// provided, it will use [imageBytes] instead.
///
/// Example usage in a test case:
///
/// ```
/// void main() {
///  testWidgets('should not crash', (WidgetTester tester) async {
///    provideMockedNetworkImages(() async {
///      await tester.pumpWidget(
///        MaterialApp(
///          home: Image.network('https://example.com/image.png'),
///        ),
///      );
///    });
///  });
/// }
/// ```
///
/// Note that you'll want to add this package to the dev_dependencies instead of
/// the regular dependencies block on your pubspec.yaml.
///
/// For more context about [Image.network] widgets failing in widget tests, see
/// these issues:
///
/// * https://github.com/flutter/flutter/issues/13433
/// * https://github.com/flutter/flutter_markdown/pull/17
///
/// The underlying code is taken from the Flutter repo:
/// https://github.com/flutter/flutter/blob/master/dev/manual_tests/test/mock_image_http.dart
R provideMockedNetworkImages<R>(R Function() body,
    {List<int> imageBytes = _transparentImage}) {
  return HttpOverrides.runZoned(
    body,
    createHttpClient: (_) => _createMockImageHttpClient(_, imageBytes),
  );
}

class MockHttpClient extends Mock implements HttpClient {}

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

class MockHttpClientResponse extends Mock implements HttpClientResponse {}

class MockHttpHeaders extends Mock implements HttpHeaders {}

// Returns a mock HTTP client that responds with an image to all requests.
MockHttpClient _createMockImageHttpClient(
    SecurityContext _, List<int> imageBytes) {
  final client = MockHttpClient();
  final request = MockHttpClientRequest();
  final response = MockHttpClientResponse();
  final headers = MockHttpHeaders();

  when(client.getUrl(any))
      .thenAnswer((_) => Future<HttpClientRequest>.value(request));
  when(request.headers).thenReturn(headers);
  when(request.close())
      .thenAnswer((_) => Future<HttpClientResponse>.value(response));
  when(response.contentLength).thenReturn(_transparentImage.length);
  when(response.statusCode).thenReturn(HttpStatus.ok);
  when(response.listen(any)).thenAnswer((Invocation invocation) {
    final onData =
        invocation.positionalArguments[0] as void Function(List<int> p1);
    final onDone = invocation.namedArguments[#onDone] as void Function();
    final onError = invocation.namedArguments[#onError] as void
        Function(Object p1, [StackTrace p2]);
    final cancelOnError = invocation.namedArguments[#cancelOnError] as bool;

    return Stream<List<int>>.fromIterable(<List<int>>[imageBytes]).listen(
        onData,
        onDone: onDone,
        onError: onError,
        cancelOnError: cancelOnError);
  });

  return client;
}

const List<int> _transparentImage = <int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
];
