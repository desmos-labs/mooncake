import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:mooncake/entities/entities.dart';
import 'package:url_launcher/url_launcher.dart';

/// Displays the message of a post properly.
class PostMessage extends StatelessWidget {
  final Post post;

  const PostMessage({Key key, @required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: MarkdownBody(
            onTapLink: _onTapLink,
            data: post.message.replaceAll('\n', '  \n'),
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
            extensionSet: md.ExtensionSet.gitHubFlavored,
          ),
        ),
      ],
    );
  }

  void _onTapLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
