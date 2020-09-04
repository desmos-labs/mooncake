import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// Allows the user to visualize the counter of the likes that a post has.
class PostLikesCounter extends StatelessWidget {
  final double iconSize = 24.0;

  final Post post;
  const PostLikesCounter({
    Key key,
    @required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final likes = post.reactions.where((react) => react.isLike).toList();
    final likesCount = likes.length;

    List<Widget> _generateIcons() {
      var finalResults = <Widget>[];
      final margin = 15.0;
      final count = likesCount > 6 ? 6 : likesCount;

      for (var i = 0; i < count; i++) {
        finalResults.add(
          Positioned(
            left: margin * i,
            child: AccountAvatar(
              size: iconSize - 2,
              border: 1,
              user: likes[i].user,
            ),
          ),
        );
      }

      if (likesCount > 6) {
        finalResults.add(
          Positioned(
            left: margin * 6.6,
            bottom: 0,
            child: Text(
              '...',
              style: TextStyle(fontSize: 13),
            ),
          ),
        );
      }

      return finalResults;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Stack(children: [
            Container(
              height: iconSize,
              child: Stack(
                children: <Widget>[
                  ..._generateIcons(),
                ],
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
