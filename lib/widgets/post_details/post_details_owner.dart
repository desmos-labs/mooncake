import 'package:desmosdemo/keys.dart';
import 'package:desmosdemo/models/models.dart';
import 'package:desmosdemo/theme/theme.dart';
import 'package:flutter/material.dart';

class PostDetailsOwner extends StatelessWidget {
  final User user;

  const PostDetailsOwner({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            user.address,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            key: PostsKeys.postDetailsOwnerAddress,
          ),
          SizedBox(
            height: 4,
          ),
          user.hasUsername
              ? Text(
                  user.username,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: PostsTheme.textColorLight),
                )
              : Container(),
        ],
      ),
    );
  }
}
