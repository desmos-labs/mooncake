import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:url_launcher/url_launcher.dart';

/// Displays the message of a post properly.
class PostMessage extends StatelessWidget {
  final Post post;
  final double messageFontSize;

  const PostMessage({
    Key key,
    @required this.post,
    this.messageFontSize = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double fontSize = theme.textTheme.bodyText2.fontSize;
    if (this.messageFontSize > 0.0) {
      fontSize = this.messageFontSize;
    }

    final messageTheme = theme.textTheme.bodyText2.copyWith(
      fontSize: fontSize,
    );
    final mdStyle = MarkdownStyleSheet.fromTheme(theme).copyWith(
      p: messageTheme,
    );

    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              MarkdownBody(
                onTapLink: _onTapLink,
                data: post.message,
                styleSheet: mdStyle,
              ),
            ],
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
