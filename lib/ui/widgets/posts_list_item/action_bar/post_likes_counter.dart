import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/blocs/export.dart';
import 'package:mooncake/ui/localization/export.dart';
import 'package:mooncake/ui/ui.dart';

/// Allows the user to visualize the counter of the likes that a post has.
class PostLikesCounter extends StatelessWidget {
  final double iconSize = 26.0;

  final Post post;
  const PostLikesCounter({
    Key key,
    @required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final likes = post.reactions.where((react) => react.isLike).toList();
    final likesCount = likes.length;

    final double afterIconSize = iconSize * 0.75;
    double iconsWidth = 0.0;
    if (likesCount > 0) {
      iconsWidth += iconSize;
    }

    if (likesCount > 1) {
      iconsWidth += afterIconSize;
    }

    if (likesCount > 2) {
      iconsWidth += afterIconSize;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: iconsWidth,
          height: iconSize,
          child: Stack(
            children: <Widget>[
              if (likesCount > 2)
                Positioned(
                  right: afterIconSize * 2,
                  child: UserAvatar(
                    border: 1,
                    size: iconSize - 2,
                    user: likes[2].user,
                  ),
                ),
              if (likesCount > 1)
                Positioned(
                  right: afterIconSize,
                  child: UserAvatar(
                    border: 1,
                    size: iconSize - 2,
                    user: likes[1].user,
                  ),
                ),
              if (likesCount > 0)
                Positioned(
                  right: 0,
                  child: UserAvatar(
                    size: iconSize - 2,
                    border: 1,
                    user: likes[0].user,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
