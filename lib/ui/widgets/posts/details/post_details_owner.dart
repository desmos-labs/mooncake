import 'package:desmosdemo/ui/ui.dart';
import 'package:flutter/material.dart';

class PostDetailsOwner extends StatelessWidget {
  /// Bech32 address of the user
  final String user;

  const PostDetailsOwner({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            user,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            key: PostsKeys.postDetailsOwnerAddress,
          ),
          SizedBox(
            height: 4,
          ),
// TODO: Implement this again
//          user.hasUsername
//              ? Text(
//                  user.username,
//                  overflow: TextOverflow.ellipsis,
//                  style: TextStyle(color: PostsTheme.textColorLight),
//                )
//              : Container(),
        ],
      ),
    );
  }
}
