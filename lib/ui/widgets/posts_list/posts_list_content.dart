import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the list of posts that is shown to the user when there are
/// some posts to be shown.
class PostsListContent extends StatelessWidget {
  final List<Post> posts;

  const PostsListContent({
    Key key,
    @required this.posts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: PostsKeys.postsList,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return PostListItem(post: post);
      },
    );
  }
}
