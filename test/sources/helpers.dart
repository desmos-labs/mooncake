import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

/// Allows to create an http mock response having the given [body] and [status].
http.Response simpleResponse({@required String body, int status}) {
  return http.Response(body, status ?? 200, headers: {
    'Content-Type': 'application/json',
    'Authorization': '',
  });
}
