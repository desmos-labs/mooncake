import 'package:desmosdemo/blocs/blocs.dart';
import 'package:desmosdemo/keys.dart';
import 'package:desmosdemo/models/models.dart';
import 'package:desmosdemo/theme/theme.dart';
import 'package:desmosdemo/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Represents a single entry inside a list of [Post] objects.
/// It is made of the following components:
/// - a [UserAvatar] object, containing the avatar of the post creator.
/// - a [PostItemHeader] object containing information such as the post
///    creator's username, his address and the creation date
/// - a [Text] containing the actual post message
/// - a [PostActionBar] containing all the actions that can be performed
///    for such post
class PostItem extends StatelessWidget {
  final GestureTapCallback onTap;
  final String postId;

  PostItem({
    Key key,
    @required this.onTap,
    @required this.postId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsBloc, PostsState>(
      builder: (context, state) {
        // Make sure we loaded the posts properly
        assert(state is PostsLoaded);

        final post = (state as PostsLoaded).posts.findById(postId);
        return InkWell(
          onTap: onTap,
          child: Container(
            padding: PostsTheme.postItemPadding,
            child: Row(
              children: <Widget>[
                UserAvatar(
                  key: PostsKeys.postItemOwnerAvatar(postId),
                  user: post.owner,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      PostItemHeader(
                        key: PostsKeys.postItemOwner(post.id),
                        post: post,
                      ),
                      SizedBox(height: 4),
                      Text(
                        post.message,
                        key: PostsKeys.postItemMessage(post.id),
                      ),
                      SizedBox(height: 8),
                      PostActionsBar(
                        key: PostsKeys.postActionsBar(post.id),
                        postId: postId,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
