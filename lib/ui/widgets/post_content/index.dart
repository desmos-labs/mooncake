import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
// import 'package:mooncake/ui/ui.dart';

// import 'header/export.dart';
// import 'text/export.dart';
// import 'images/export.dart';
// import 'poll/export.dart';

/// Contains the main content of a post. Such content is made of
/// - The header of the post, indicating the creator and the data
/// - The main message of the post
/// - The image(s) associated to the post
class PostContent extends StatelessWidget {
  final Post post;
  const PostContent({Key key, @required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        PostItemHeader(key: PostsKeys.postItemHeader(post.id), post: post),
        const SizedBox(height: ThemeSpaces.smallGutter),
        if (post.message?.isNotEmpty == true) _messagePreview(),
        if (post.poll != null) PostPollContent(post: post),
        PostImagesPreviewer(
          key: PostsKeys.postItemImagePreviewer(post.id),
          post: post,
        ),
      ],
    );
  }

  Widget _messagePreview() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PostMessage(key: PostsKeys.postItemMessage(post.id), post: post),
        const SizedBox(height: ThemeSpaces.smallGutter),
      ],
    );
  }
}
