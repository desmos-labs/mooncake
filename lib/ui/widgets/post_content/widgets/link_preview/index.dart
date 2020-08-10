import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:url_launcher/url_launcher.dart';

/// Takes in a `RichLinkPreview` and displays such link preview.
class LinkPreview extends StatelessWidget {
  final RichLinkPreview preview;

  const LinkPreview({@required this.preview});

  @override
  Widget build(BuildContext context) {
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
            Image.network(
              preview.image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace stackTrace) {
                return Container(width: 100, height: 100);
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      preview.title,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      softWrap: false,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      preview.description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 14),
                    ),
                    Text(
                      preview.url,
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
    if (await canLaunch(preview.url)) {
      await launch(preview.url);
    }
  }
}
