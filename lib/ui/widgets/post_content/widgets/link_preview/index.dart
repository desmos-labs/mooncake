import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import './utils/preview_helper.dart';

class LinkPreview extends StatefulWidget {
  final String url;
  // wingman clean up
  const LinkPreview(
      {this.url =
          'https://nealschaffer.com/tweet-link-preview-image-twitter/'});

  @override
  _LinkPreviewState createState() => _LinkPreviewState();
}

class _LinkPreviewState extends State<LinkPreview> {
  Map<String, String> data;

  @override
  void initState() {
    super.initState();
    fetchPreview(widget.url).then((Map<String, String> res) {
      setState(() {
        data = res;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        _openUrl();
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.5,
            color: Theme.of(context).colorScheme.onError,
          ),
        ),
        child: Row(
          children: [
            Image.network(data['image'],
                width: 100, height: 100, fit: BoxFit.cover),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['title'],
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      softWrap: false,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      data['description'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 14),
                    ),
                    Text(
                      widget.url,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _openUrl() async {
    final url = widget.url;
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
