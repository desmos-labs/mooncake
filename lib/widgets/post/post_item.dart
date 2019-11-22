import 'package:desmosdemo/keys.dart';
import 'package:desmosdemo/models/models.dart';
import 'package:desmosdemo/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Represents a single entry inside a list of [Post] objects.
/// It is made of the following components: 
/// - a [PostAvatar] object, containing the avatar of the post creator. 
/// - a [PostHeader] object containing information such as the post
///    creator's username, his address and the creation date
/// - a [Text] containing the actual post message
/// - a [PostActionBar] containing all the actions that can be performed
///    for such post
class PostItem extends StatelessWidget {
  final GestureTapCallback onTap;
  final Post post;

  PostItem({
    Key key,
    @required this.onTap,
    @required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Row(
          children: <Widget>[
            PostAvatar(key: PostsKeys.postItemOwnerAvatar(post.id), url: ''),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PostHeader(
                    key: PostsKeys.postItemOwner(post.id),
                    post: post,
                  ),
                  SizedBox(height: 4),
                  Text(
                    post.message,
                    key: PostsKeys.postItemMessage(post.id),
                  ),
                  PostActionsBar(
                    key: PostsKeys.postActionsBar(post.id),
                    post: post,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
