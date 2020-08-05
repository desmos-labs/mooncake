import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// Allows to display the list of posts that have been created by the
/// given [user].
class AccountPostsViewer extends StatelessWidget {
  final List<Post> posts;

  const AccountPostsViewer({
    Key key,
    @required this.posts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsListBloc, PostsListState>(
      builder: (context, postsState) {
        if (posts.isEmpty) {
          return PostsListEmptyContainer();
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: posts.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return PostListItem(post: posts[index]);
          },
        );
      },
    );
  }
}
