import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Represents a single image items that should be displayed as part
/// of the post content.
class PostContentImage extends StatelessWidget {
  final String url;

  const PostContentImage({Key key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: _openImage,
        child: Image(
          width: double.infinity,
          fit: BoxFit.cover,
          image: NetworkImage(url),
        ),
      ),
    );
  }

  void _openImage() async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
