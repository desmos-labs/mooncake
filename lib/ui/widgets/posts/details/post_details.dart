import 'package:dwitter/entities/entities.dart';
import 'package:dwitter/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'post_details_owner.dart';

/// Represents the widget that should be used when wanting to display
/// the details of a [postId]. It is made of:
/// - a [UserAvatar] containing the owner profile picture
/// - a [PostDetailsOwner] containing the details of the post creator
/// - a [Text] which contains the actual post message
class PostDetails extends StatelessWidget {
  final String postId;

  const PostDetails({Key key, this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsBloc, PostsState>(
      builder: (context, state) {
        // Make sure we have loaded the posts properly
        assert(state is PostsLoaded);

        final post = (state as PostsLoaded).posts.firstBy(id: postId);
        return Padding(
          padding: PostsTheme.postItemPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  UserAvatar(
                    user: post.owner,
                    key: PostsKeys.postItemOwnerAvatar(post.id),
                  ),
                  SizedBox(width: 16),
                  PostDetailsOwner(
                    user: post.owner,
                    key: PostsKeys.postDetailsOwner,
                  )
                ],
              ),
              SizedBox(height: 16),
              Text(
                post.message,
                key: PostsKeys.postDetailsMessage,
                style: Theme.of(context).textTheme.headline,
              ),
            ],
          ),
        );
      },
    );
  }
}
