import 'package:flutter/material.dart';
import './utils/preview_helper.dart';

class LinkPreview extends StatefulWidget {
  final String url;
  const LinkPreview({this.url = 'http://github.com/'});

  @override
  _LinkPreviewState createState() => _LinkPreviewState();
}

class _LinkPreviewState extends State<LinkPreview> {
  Map<String, String> data;

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   data = {
    //     "title": "Build software better, taasogether",
    //     "description":
    //         "GitHub is where people build software. More than 50 million people use GitHub to discover, fork, and contribute to over 100 million projects.",
    //     "image":
    //         "https://github.githubassets.com/images/modules/open_graph/github-octocat.png",
    //     "appleIcon": "",
    //     "favIcon": "https://github.githubassets.com/favicons/favicon.svg",
    //   };
    // });
    fetchPreview(widget.url).then((Map<String, String> res) {
      setState(() {
        data = res;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('=====build me bitch====');
    print(data);
    if (data == null) {
      return Container();
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: Theme.of(context).colorScheme.onError,
        ),
      ),
      child: Row(
        children: [
          Image.network(
            data['image'],
            width: 100,
            height: 100,
          ),
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
                    overflow: TextOverflow.fade,
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
                        .copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
