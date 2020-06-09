import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/blocs/export.dart';
import 'package:mooncake/ui/ui.dart';

/// Allows to display the list of posts that have been created by the
/// given [user].
class AccountPostsViewer extends StatelessWidget {
  final User user;

  const AccountPostsViewer({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsListBloc, PostsListState>(
      builder: (context, postsState) {
        if (!(postsState is PostsLoaded)) {
          return Container();
        }

        final state = postsState as PostsLoaded;
        final posts = state.posts
            .where((post) => post.owner.address == user.address)
            .toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: state.hasReachedMax ? posts.length : posts.length + 1,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return index >= posts.length
                ? BottomLoader()
                : PostListItem(post: posts[index]);
          },
        );
      },
    );
  }
}
