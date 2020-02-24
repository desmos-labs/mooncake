import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

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

    return Column(
      children: [
        const SizedBox(height: PostsTheme.defaultPadding),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MarkdownBody(
                    data: post.message,
                    styleSheet: mdStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
