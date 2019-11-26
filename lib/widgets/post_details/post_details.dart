import 'package:desmosdemo/keys.dart';
import 'package:desmosdemo/models/models.dart';
import 'package:desmosdemo/widgets/widgets.dart';
import 'package:flutter/material.dart';

/// Represents the widget that should be used when wanting to display
/// the details of a [post]. It is made of:
/// - a [UserAvatar] containing the owner profile picture
/// - a [PostDetailsOwner] containing the details of the post creator
/// - a [Text] which contains the actual post message
class PostDetails extends StatelessWidget {
  final Post post;

  const PostDetails({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            UserAvatar(
              user: post.owner,
              key: PostsKeys.postItemOwnerAvatar(post.id),
            ),
            PostDetailsOwner(
              user: post.owner,
              key: PostsKeys.postDetailsOwner,
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            post.message,
            key: PostsKeys.postDetailsMessage,
            style: Theme.of(context).textTheme.headline,
          ),
        )
      ],
    );
  }
}
