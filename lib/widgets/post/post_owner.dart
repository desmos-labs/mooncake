import 'package:desmosdemo/models/models.dart';
import 'package:flutter/material.dart';

/// Contains the info that are shown on top of a [PostItem]. The following
/// data are :
/// - the owner o the post
/// - the block height at which the post has been created
///
/// TODO: Add the username (maybe using Starnames?)
class PostHeader extends StatelessWidget {
  final Post post;

  PostHeader({
    @required this.post,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: post.owner,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
          TextSpan(
            text: ' Block heigh: ${post.created}',
          ),
        ],
      ),
    );
  }
}
