import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the list of posts that is shown to the user when there are
/// some posts to be shown.
class PostsListContent extends StatelessWidget {
  final List<Post> posts;

  const PostsListContent({Key key, this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: PostsKeys.postsList,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return _postWidget(context, posts[index]);
      },
    );
  }

  Widget _postWidget(BuildContext buildContext, Post post) {
    return BlocProvider<PostListItemBloc>(
      create: (context) => PostListItemBloc.create(context, post),
      child: PostListItem(postId: post.id),
    );
  }
}
