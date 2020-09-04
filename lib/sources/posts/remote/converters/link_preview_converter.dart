import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:validators/validators.dart';

/// Allows to convert a [Post] to a [UiPost] instance fetching the
/// appropriate link preview (if any).
class LinkPreviewConverter {
  /// Takes in a `List<String>` of `urls` and tries to fetch
  /// an url with enough meta data for a preview. Will return `null` if none is found.
  static Future<RichLinkPreview> fetchPreview(Post post) async {
    var urls = _getUrisToPreview(post);
    for (var i = urls.length - 1; i >= 0; i--) {
      var data = await _fetchSinglePreview(urls[i]);
      if (data != null) return data;
    }
    return null;
  }

  /// Returns the list of links that should be used when trying
  /// to get a proper preview.
  /// If the post contains a poll or one or images, an empty
  /// list will be returned.
  static List<String> _getUrisToPreview(Post post) {
    // do not show link preview if there is a poll or image
    if (post.poll != null || post.images.isNotEmpty) {
      return [];
    }

    return post.message
        .replaceAll('\n', '  \n')
        .split(' ')
        .where((String x) => isURL(x))
        .toList();
  }

  /// Takes in a single url and tries to fetch enough meta data for a
  /// preview. Will return null if there isn't enough.
  static Future<RichLinkPreview> _fetchSinglePreview(String url) async {
    final client = Client();
    final response = await client.get(_validateUrl(url));
    final document = parse(response.body);
    String description, title, image, appleIcon, favIcon;

    var elements = document.getElementsByTagName('meta');
    final linkElements = document.getElementsByTagName('link');

    elements.forEach((tmp) {
      if (tmp.attributes['property'] == 'og:title' ||
          tmp.attributes['property'] == 'og:site_name') {
        //fetch seo title
        title = tmp.attributes['content'];
      }
      //if seo title is empty then fetch normal title
      if (title == null || title.isEmpty) {
        List fetchTitle = document.getElementsByTagName('title');
        if (fetchTitle.isNotEmpty) {
          title = document.getElementsByTagName('title')[0].text;
        }
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

    if (title == null || description == null || image == null) {
      return null;
    }

    return RichLinkPreview(
      title: title,
      description: description,
      image: image,
      appleIcon: appleIcon,
      favIcon: favIcon,
      url: url,
    );
  }

  static String _validateUrl(String url) {
    if (url?.startsWith('http://') == true ||
        url?.startsWith('https://') == true) {
      return url;
    } else {
      return 'http://$url';
    }
  }
}
