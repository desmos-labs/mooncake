import 'package:html/parser.dart';
import 'package:http/http.dart';

Future<Map<String, String>> fetchPreview(String url) async {
  final client = Client();
  final response = await client.get(_validateUrl(url));
  final document = parse(response.body);
  String description, title, image, appleIcon, favIcon;

  var elements = document.getElementsByTagName('meta');
  final linkElements = document.getElementsByTagName('link');

  elements.forEach((tmp) {
    if (tmp.attributes['property'] == 'og:title') {
      //fetch seo title
      title = tmp.attributes['content'];
    }
    //if seo title is empty then fetch normal title
    if (title == null || title.isEmpty) {
      title = document.getElementsByTagName('title')[0].text;
    }

    //fetch seo description
    if (tmp.attributes['property'] == 'og:description') {
      description = tmp.attributes['content'];
    }
    //if seo description is empty then fetch normal description.
    if (description == null || description.isEmpty) {
      //fetch base title
      if (tmp.attributes['name'] == 'description') {
        description = tmp.attributes['content'];
      }
    }

    //fetch image
    if (tmp.attributes['property'] == 'og:image') {
      image = tmp.attributes['content'];
    }
  });

  linkElements.forEach((tmp) {
    if (tmp.attributes['rel'] == 'apple-touch-icon') {
      appleIcon = tmp.attributes['href'];
    }
    if (tmp.attributes['rel']?.contains('icon') == true) {
      favIcon = tmp.attributes['href'];
    }
  });

  return {
    'title': title ?? '',
    'description': description ?? '',
    'image': image ?? 'https://via.placeholder.com/100',
    'appleIcon': appleIcon ?? '',
    'favIcon': favIcon ?? ''
  };
}

String _validateUrl(String url) {
  if (url?.startsWith('http://') == true ||
      url?.startsWith('https://') == true) {
    return url;
  } else {
    return 'http://$url';
  }
}
